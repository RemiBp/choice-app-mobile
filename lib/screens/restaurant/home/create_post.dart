import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'producer_post_provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';
import '../../../utilities/extensions.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        leading: BackButton(),
        elevation: 0,
      ),
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
                CustomText(
                  text: "Photos",
                  fontFamily: Assets.onsetMedium,
                  fontSize: sizes?.fontSize16,
                ),
                CustomText(
                  text: "File supported: PNG, JPG",
                  fontSize: sizes?.fontSize12,
                ),
                Container(
                  height: getHeight() * .2,
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.greyBordersColor,
                      )
                  ),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Choose a file",
                            fontFamily: Assets.onsetMedium,
                            fontSize: sizes?.fontSize14,
                          ),
                          CustomText(
                            text: "Up to 5 images",
                            fontSize: sizes?.fontSize14,
                            color: HexColor.fromHex("#686A82"),
                          ),

                        ],
                      )
                  ),
                ),
              ],
            ),

            SizedBox(height: getHeight() * .02),
            CustomField(
              controller: _titleController,
              borderColor: AppColors.greyBordersColor,
              hint: "e.g Sunday Brunch at The Maple House",
              label: "Title",
            ),
            SizedBox(height: getHeight() * .02),

            CustomField(
              controller: _descriptionController,
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: "Describe your event...",
              label: "Description",
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              controller: _tagsController,
              borderColor: AppColors.greyBordersColor,
              hint: "e.g: #cozy, #outdoor_seating",
              label: "Tags",
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              controller: _locationController,
              borderColor: AppColors.greyBordersColor,
              hint: "Add location",
              label: "Location",
              suffixIcon:Icons.location_on,
              obscure: true, // Note: obscure used for readOnly/click behavior in old code? Checking logic...
            ),
            SizedBox(height: getHeight() * .02),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getHeight() * .02,
                horizontal: getWidth() * .05,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: getHeight() * .055,
                      backgroundColor: Colors.transparent,
                      buttonText: "Cancel",
                      textColor: Colors.black,
                      borderColor: Colors.black,
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: getHeight() * .055,
                      buttonText: "Publish",
                      onTap: () async {
                        if (_descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a description")),
                          );
                          return;
                        }

                        final provider = context.read<ProducerPostProvider>();
                        final success = await provider.createPost(
                          description: _descriptionController.text,
                          // images: ... (Pass selected images if implemented)
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text("Post created successfully!")),
                          );
                          if (Navigator.canPop(context)) {
                             Navigator.pop(context);
                          }
                        } else if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(provider.errorMessage ?? "Failed to create post")),
                           );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
