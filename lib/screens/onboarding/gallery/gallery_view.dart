import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../res/res.dart';
import '../onboarding_provider.dart';
import 'gallery_widgets.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final ImagePicker imgPicker = ImagePicker();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().fetchRestaurantImages();
    });
  }

  Future<void> _pickImages(OnboardingProvider provider) async {
    final List<XFile>? selectedImages = await imgPicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      final List<File> files = selectedImages.map((xfile) => File(xfile.path)).toList();
      await provider.uploadRestaurantImages(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "Gallery"),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
            child: Column(
              children: [
                SizedBox(height: getHeightRatio() * 16),
                Expanded(
                  child: provider.isLoading && provider.restaurantImages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(
                            vertical: getHeight() * 0.02,
                          ),
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ...provider.restaurantImages.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final image = entry.value;
                                    return GalleryCard(
                                      isMainImage: image['isMain'] ?? false,
                                      imageFile: image['imageUrl'],
                                      imageId: image['id'],
                                      onSetMainImage: (id) async {
                                        final success = await provider.setMainImage(id);
                                        if (success && mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Main image updated successfully')),
                                          );
                                        }
                                      },
                                      onRemoveImage: (id) async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Image'),
                                            content: const Text('Are you sure you want to delete this image?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true && mounted) {
                                          final success = await provider.deleteRestaurantImage(id);
                                          if (success && mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Image deleted successfully')),
                                            );
                                          }
                                        }
                                      },
                                    );
                                }),
                                AddImageCard(
                                  onAddImages: () => _pickImages(provider),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                if (provider.errorMessage != null) ...[
                  CustomText(
                    text: provider.errorMessage!,
                    color: Colors.red,
                    fontSize: sizes?.fontSize12,
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      buttonText: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.blackColor,
                      textColor: AppColors.blackColor,
                      textFontWeight: FontWeight.w700,
                    ),
                    CustomButton(
                      buttonText: provider.isLoading ? 'Processing...' : 'Save Changes',
                      onTap: provider.isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: provider.isLoading
                          ? AppColors.textGreyColor
                          : AppColors.getPrimaryColorFromContext(context),
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: getHeightRatio() * 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
