import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/providers/producer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appAssets/app_assets.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Description is required');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final rawTags = _tagsController.text.trim();
    final tags = rawTags.isEmpty
        ? <String>[]
        : rawTags
            .split(',')
            .map((t) => t.trim().replaceAll('#', ''))
            .where((t) => t.isNotEmpty)
            .toList();

    final body = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'tags': tags,
      'location': _locationController.text.trim(),
    };

    final result = await context.read<ProducerProvider>().createPost(body);
    setState(() => _isSubmitting = false);

    if (result.success) {
      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() => _errorMessage = result.message ?? 'Failed to publish post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: const BackButton(),
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
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.greyBordersColor),
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
                          color: AppColors.inputHintColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: "e.g Sunday Brunch at The Maple House",
              label: "Title",
              textEditingController: _titleController,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              height: getHeight() * .1,
              borderColor: AppColors.greyBordersColor,
              hint: "Describe your post...",
              label: "Description",
              textEditingController: _descriptionController,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: "e.g: #cozy, #outdoor_seating",
              label: "Tags",
              textEditingController: _tagsController,
            ),
            SizedBox(height: getHeight() * .02),
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: "Add location",
              label: "Location",
              suffixIcon: Icons.location_on,
              obscure: true,
              textEditingController: _locationController,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red)),
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
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: getHeight() * .055,
                      buttonText: _isSubmitting ? '...' : "Publish",
                      onTap: _isSubmitting ? null : _publish,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
