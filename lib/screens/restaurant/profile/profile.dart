import 'dart:io';
import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/screens/restaurant/profile/profile_widgets.dart';
import 'package:choice_app/services/producer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../l18n.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _instagramController = TextEditingController();
  final _twitterController = TextEditingController();
  final _facebookController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  String? _errorMessage;
  String? _successMessage;
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ProducerProvider>();
      await provider.loadProfile();
      _prefillFromProfile(provider.profile);
    });
  }

  void _prefillFromProfile(Map<String, dynamic>? p) {
    if (p == null) return;
    _addressController.text = p['address'] as String? ?? '';
    _websiteController.text = p['website'] as String? ?? '';
    _instagramController.text = p['instagram'] as String? ?? '';
    _twitterController.text = p['twitter'] as String? ?? '';
    _facebookController.text = p['facebook'] as String? ?? '';
    _bioController.text = p['description'] as String? ?? p['bio'] as String? ?? '';
    _profilePhotoUrl = p['profilePhoto'] as String? ?? p['logo'] as String?;
    setState(() {});
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final file = File(picked.path);
      final fileName = picked.name;
      const contentType = 'image/jpeg';

      final urlResult = await ProducerProfileService.getPreSignedUrl(
        fileName: fileName,
        contentType: contentType,
        folderName: 'profile',
      );
      if (!urlResult.success || urlResult.data == null) {
        setState(() { _errorMessage = 'Failed to get upload URL'; _isUploadingPhoto = false; });
        return;
      }
      final presignedUrl = urlResult.data!['url'] as String;
      final keyName = urlResult.data!['keyName'] as String;

      final uploaded = await ProducerProfileService.uploadToS3(
        presignedUrl: presignedUrl,
        file: file,
        contentType: contentType,
      );
      if (!uploaded) {
        setState(() { _errorMessage = 'Photo upload failed'; _isUploadingPhoto = false; });
        return;
      }

      await context.read<ProducerProvider>().updateProfile({'profilePhoto': keyName});
      setState(() { _profilePhotoUrl = keyName; _isUploadingPhoto = false; });
    } catch (_) {
      setState(() { _errorMessage = 'Photo upload failed'; _isUploadingPhoto = false; });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final body = <String, dynamic>{};
    if (_addressController.text.trim().isNotEmpty)
      body['address'] = _addressController.text.trim();
    if (_websiteController.text.trim().isNotEmpty)
      body['website'] = _websiteController.text.trim();
    if (_instagramController.text.trim().isNotEmpty)
      body['instagram'] = _instagramController.text.trim();
    if (_twitterController.text.trim().isNotEmpty)
      body['twitter'] = _twitterController.text.trim();
    if (_facebookController.text.trim().isNotEmpty)
      body['facebook'] = _facebookController.text.trim();
    if (_bioController.text.trim().isNotEmpty)
      body['description'] = _bioController.text.trim();

    final result = await context.read<ProducerProvider>().updateProfile(body);
    if (!mounted) return;

    setState(() {
      _isSaving = false;
      if (result.success) {
        _successMessage = 'Profile updated successfully.';
      } else {
        _errorMessage = result.message ?? 'Failed to update profile.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (context.canPop()) ...[
                  CustomBackButton(),
                  SizedBox(width: getWidth() * .02),
                ],
                CustomText(
                  text: al.profileSetup,
                  fontSize: sizes?.fontSize28,
                  fontFamily: Assets.onsetSemiBold,
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.uploadDocumentsSubtitle,
              fontSize: sizes?.fontSize16,
              color: AppColors.primarySlateColor,
              giveLinesAsText: true,
            ),
            SizedBox(height: getHeight() * .02),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: getHeight() * .07,
                  backgroundColor: AppColors.greyColor,
                  backgroundImage: _profilePhotoUrl != null
                      ? NetworkImage(_profilePhotoUrl!)
                      : null,
                  child: _profilePhotoUrl == null
                      ? SvgPicture.asset(
                          Assets.userIcon,
                          height: getHeight() * .05,
                          color: Colors.grey.shade600,
                        )
                      : null,
                ),
                if (_isUploadingPhoto)
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.restaurantPrimaryColor,
                    ),
                    onPressed: _pickAndUploadPhoto,
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: getHeight() * .022,
                    ),
                  ),
              ],
            ),
            SizedBox(height: getHeight() * .03),
            CustomField(
              textEditingController: _addressController,
              borderColor: AppColors.greyBordersColor,
              hint: al.address,
              label: al.address,
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.phoneNumber,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .01),
            PhoneFormField(
              initialValue: PhoneNumber.parse('+33'),
              countrySelectorNavigator: const CountrySelectorNavigator.page(),
              onChanged: (_) {},
              decoration: InputDecoration(
                border: buildOutlineInputBorder(AppColors.greyBordersColor),
                focusedBorder:
                    buildOutlineInputBorder(AppColors.inputHintColor),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              enabled: true,
              isCountrySelectionEnabled: true,
              isCountryButtonPersistent: true,
              countryButtonStyle: const CountryButtonStyle(
                showDialCode: true,
                showIsoCode: true,
                showFlag: true,
                flagSize: 16,
              ),
            ),
            SizedBox(height: getHeight() * .02),
            CustomText(
              text: al.links,
              fontSize: sizes!.fontSize14,
              fontFamily: Assets.onsetMedium,
            ),
            SizedBox(height: getHeight() * .01),
            CustomField(
              textEditingController: _websiteController,
              borderColor: AppColors.greyBordersColor,
              hint: "yoursite.io",
              prefixIconSvg: Assets.websiteIcon,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: _instagramController,
              borderColor: AppColors.greyBordersColor,
              hint: "https://www.instagram.com/@yourhan...",
              prefixIconSvg: Assets.instagramIcon,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: _twitterController,
              borderColor: AppColors.greyBordersColor,
              hint: "https://www.twitter.com/@yourhandle...",
              prefixIconSvg: Assets.xIcon,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: _facebookController,
              borderColor: AppColors.greyBordersColor,
              hint: "https://www.facebook.com/@yourhan...",
              prefixIconSvg: Assets.facebookIcon,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: _bioController,
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: al.writeSomethingBrief,
              label: al.briefDescription,
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: getHeight() * .01),
              Text(
                _errorMessage!,
                style: TextStyle(
                    color: Colors.red, fontSize: sizes?.fontSize12),
              ),
            ],
            if (_successMessage != null) ...[
              SizedBox(height: getHeight() * .01),
              Text(
                _successMessage!,
                style: TextStyle(
                    color: Colors.green, fontSize: sizes?.fontSize12),
              ),
            ],
            SizedBox(height: getHeight() * .03),
            CustomButton(
              buttonText: _isSaving ? '...' : al.next,
              onTap: _isSaving ? null : _onSave,
            ),
          ],
        ),
      ),
    );
  }
}
