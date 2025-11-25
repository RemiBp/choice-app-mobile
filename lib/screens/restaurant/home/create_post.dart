import 'dart:io';

import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import '../../../utilities/extensions.dart';
import 'choice_provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  NetworkProvider networkProvider = NetworkProvider();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<XFile> images = [];
  List<String> imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  // Function to pick images
  Future<void> _pickImages() async {
    if (images.length >= 5) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(pickedFile);
      });
    }

  }

  // Remove image
  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.context = context;

  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final choiceProvider = Provider.of<ChoiceProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar:CommonAppBar(title: al.createPost),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth() * .05,
          vertical: getHeight() * .02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: al.photos,
                      fontFamily: Assets.onsetMedium,
                      fontSize: sizes?.fontSize16,
                    ),
                    CustomText(
                      text: " *",
                      fontSize: sizes?.fontSize16,
                      color: Colors.red,
                    ),
                  ],
                ),
                CustomText(
                  text: "${al.fileSupported} PNG, JPG",
                  fontSize: sizes?.fontSize12,
                ),
                SizedBox(height: getHeight() * .02),
                GestureDetector(
                  onTap: _pickImages,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: getWidth() * 0.91,   // ~342px on standard widths
                      height: getHeight() * 0.25, // ~200px on standard heights                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.greyBordersColor,
                          )
                      ),
                      child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: al.chooseFile,
                                fontFamily: Assets.onsetMedium,
                                fontSize: sizes?.fontSize14,
                              ),
                              CustomText(
                                text: al.imageLimit,
                                fontSize: sizes?.fontSize14,
                                color: HexColor.fromHex("#686A82"),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),
                if (images != null && images.isNotEmpty)
                  SizedBox(height: getHeight() * .02),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(images.length, (index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(images[index].path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => _removeImage(index),
                            child: CircleAvatar(
                              radius: getHeight() * .018,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: getHeight() * .022,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: titleController,
              borderColor: AppColors.greyBordersColor,
              hint:al.exampleTitle,
              label:al.title,
            ),
            SizedBox(height: getHeight() * .02),

            CustomField(
              textEditingController: descriptionController,
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: al.eventDescriptionPlaceholder,
              label:al.description,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: tagsController,
              borderColor: AppColors.greyBordersColor,
              hint: al.exampleTags,
              label:al.tags,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              textEditingController: locationController,
              borderColor: AppColors.greyBordersColor,
              hint: al.addLocation,
              label:al.location,
              suffixIcon:Icons.location_on,
              obscure: true,
            ),
            SizedBox(height: getHeight() * .04),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    backgroundColor: Colors.transparent,
                    buttonText: al.cancel,
                    textColor: AppColors.blackColor,
                    borderColor: AppColors.blackColor,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    borderColor: AppColors.getPrimaryColorFromContext(context),
                    buttonText: al.publish,
                    onTap: () async{
                      final title = titleController.text.trim();
                      final description = descriptionController.text.trim();
                      final tags = tagsController.text.trim();
                      final location = locationController.text.trim();
                      if (images.isEmpty) {
                        Toasts.getErrorToast(
                            text:al.errorSelectImage,);
                      } else if (title.isEmpty) {
                        Toasts.getErrorToast(
                            text: al.errorEnterTitle,);
                      }else if (description.isEmpty) {
                        Toasts.getErrorToast(
                            text: al.errorEnterDescription,);
                      }else if (tags.isEmpty) {
                        Toasts.getErrorToast(
                            text: al.errorEnterTags,);
                      }else if (location.isEmpty) {
                        Toasts.getErrorToast(
                            text: al.errorEnterAddress,);
                      }else{
                        for (var i in images) {
                          final bytes = await i.readAsBytes();
                          final fileUrl = await networkProvider
                              .getUrlForFileUpload(bytes);
                          debugPrint("file url is : $fileUrl");
                          if (fileUrl != null) {
                            imageUrls.add(fileUrl);
                          }
                        }
                        debugPrint("date : ${DateTime.now().toIso8601String()}");
                        final role = context
                            .read<RoleProvider>()
                            .role;
                        final tagsList = tagsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        choiceProvider.createChoiceApi(title: title,
                          type: role.name,
                          description: description,
                          tags: tagsList,
                          location: location,
                          images: imageUrls,);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
