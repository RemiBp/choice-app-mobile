import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/customWidgets/custom_textfield.dart';
import 'package:choice_app/customWidgets/animations/bouncing_wrapper.dart';
import 'package:choice_app/res/res.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:choice_app/screens/restaurant/profile/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import 'package:choice_app/l18n.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Sliver App Bar with Parallax
          SliverAppBar(
            expandedHeight: getHeight() * 0.25,
            pinned: true,
            backgroundColor: AppColors.getPrimaryColorFromContext(context),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                             backgroundImage: provider.profileImage != null
                               ? FileImage(provider.profileImage!)
                               : null,
                            child: provider.profileImage == null
                                ? SvgPicture.asset(Assets.userIcon, height: 40, color: Colors.grey)
                                : null,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryColorFromContext(context),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: Text(al.profileSetup, style: TextStyle(fontFamily: Assets.onsetSemiBold)),
              centerTitle: true,
            ),
             leading: context.canPop() ? BackButton(color: Colors.white) : null,
          ),

          // 2. Form Fields
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CustomText(
                    text: "Basic Info",
                    fontSize: sizes?.fontSize18,
                    fontFamily: Assets.onsetBold,
                  ),
                  SizedBox(height: 20),
                  
                  CustomField(
                    controller: _addressController,
                    borderColor: AppColors.greyBordersColor,
                    hint: al.address,
                    label: al.address,
                    prefixIconSvg: Assets.mapIcon,
                  ),
                  SizedBox(height: 16),
                  
                  CustomField(
                    controller: _passwordController,
                    borderColor: AppColors.greyBordersColor,
                    hint: al.passwordLabel,
                    label: al.passwordLabel,
                    obscure: true,
                    hidePassword: true,
                  ),
                  SizedBox(height: 20),
                  
                  CustomText(text: al.phoneNumber, fontFamily: Assets.onsetSemiBold),
                  SizedBox(height: 8),
                  PhoneFormField(
                    initialValue: PhoneNumber.parse('+33'),
                    countrySelectorNavigator: const CountrySelectorNavigator.page(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.greyBordersColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.greyBordersColor)),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  CustomText(
                    text: "Social Presence",
                    fontSize: sizes?.fontSize18,
                    fontFamily: Assets.onsetBold,
                  ),
                  SizedBox(height: 20),
                  
                  _buildSocialField(Assets.websiteIcon, "Website", _websiteController),
                  SizedBox(height: 12),
                  _buildSocialField(Assets.instagramIcon, "Instagram", _instagramController),
                  SizedBox(height: 12),
                  _buildSocialField(Assets.facebookIcon, "Facebook", _facebookController),
                  
                  SizedBox(height: 30),
                  CustomField(
                    controller: _descriptionController,
                    height: 120,
                    borderColor: AppColors.greyBordersColor,
                    hint: "Tell us about your venue...",
                    label: al.briefDescription,
                    maxLines: 4,
                  ),
                  
                  SizedBox(height: 40),
                  CustomButton(
                    buttonText: provider.isLoading ? "Saving..." : "Save & Continue",
                    onTap: provider.isLoading ? () {} : () async {
                       final success = await provider.saveProfile(
                          address: _addressController.text,
                          password: _passwordController.text,
                          website: _websiteController.text,
                          instagram: _instagramController.text,
                          facebook: _facebookController.text,
                          description: _descriptionController.text,
                       );
                       
                       if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Profile updated successfully")),
                          );
                          context.push(Routes.restaurantBottomTabRoute);
                       }
                    },
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialField(String icon, String hint, TextEditingController controller) {
    return CustomField(
      controller: controller,
      borderColor: AppColors.greyBordersColor,
      hint: hint,
      prefixIconSvg: icon,
    );
  }
}
