import 'package:choice_app/network/network_provider.dart';
import 'package:choice_app/res/toasts.dart';
import 'package:choice_app/routes/routes.dart';
import 'package:choice_app/screens/restaurant/profile/profile_provider.dart';
import 'package:choice_app/userRole/role_provider.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../l18n.dart';
import '../../../res/res.dart';
import 'gallery_widgets.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key, this.fromSettings = false});
  final bool fromSettings;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final ImagePicker imgPicker = ImagePicker();
  List<XFile> selectedImages = [];

  // Stores existing gallery images from API as a list of maps { "id": int?, "url": String }
  List<Map<String, dynamic>> galleryImages = [];

  bool isLoading = false;

  final ScrollController scrollController = ScrollController();
  late NetworkProvider networkProvider;

  @override
  void initState() {
    super.initState();
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    networkProvider.context = context;

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.init(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGalleryImages();
    });
  }

  // Fetch gallery images from API
  Future<void> _loadGalleryImages() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final response = await profileProvider.getGalleryImages(context);

    if (response != null && response.images != null) {
      setState(() {
        galleryImages = response.images!
            .where((img) => img.url != null && img.id != null)
            .map((img) => {
          "id": img.id,
          "url": img.url!.startsWith('http')
              ? img.url
              : 'https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/${img.url!}',
        })
            .toList();
      });
    } else {
      Toasts.getErrorToast(text: "Failed to load gallery images");
    }
  }

  // Pick multiple images
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await imgPicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          selectedImages.addAll(images);
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void setMainImage(int index) {
    if (index > 0) {
      setState(() {
        final XFile mainImage = selectedImages[index];
        selectedImages.removeAt(index);
        selectedImages.insert(0, mainImage);
      });
    }
  }

  // Delete a gallery image using its ID (API + local state)
  Future<void> _deleteGalleryImage(int index, int photoId) async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.deleteGalleryImage(photoIds: [photoId]);

    if (success) {
      setState(() {
        galleryImages.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.gallery),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
        child: Column(
          children: [
            SizedBox(height: getHeightRatio() * 16),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(vertical: getHeight() * 0.02),
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // --- Existing gallery images ---
                      ...galleryImages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final imageData = entry.value;
                        final String imageUrl = imageData["url"];
                        final int? photoId = imageData["id"];

                        return GalleryCard(
                          isMainImage: index == 0,
                          imageFile: imageUrl,
                          onSetMainImage: () {},
                          onRemoveImage: photoId == null
                              ? null
                              : () => _deleteGalleryImage(index, photoId),
                        );
                      }),

                      // --- Newly picked (local) images ---
                      ...selectedImages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final imageFile = entry.value;

                        return GalleryCard(
                          isMainImage: false,
                          imageFile: imageFile.path,
                          onSetMainImage: () => setMainImage(index),
                          onRemoveImage: () async => removeImage(index),
                        );
                      }),

                      // Add image button
                      AddImageCard(onAddImages: pickImages),
                    ],
                  ),
                ],
              ),
            ),

            // --- Action buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: al.cancel,
                  onTap: () => Navigator.pop(context),
                  buttonWidth: getWidth() * .42,
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.blackColor,
                  textColor: AppColors.blackColor,
                  textFontWeight: FontWeight.w700,
                ),
                CustomButton(
                  buttonText: al.saveChanges,
                  onTap: () async {
                    if (selectedImages.isEmpty) {
                      Toasts.getErrorToast(text: al.pleasePickImage);
                      return;
                    }

                    setState(() => isLoading = true);

                    List<String> urls = [];
                    for (final image in selectedImages) {
                      final bytes = await image.readAsBytes();
                      final fileUrl =
                      await networkProvider.getUrlForFileUpload(bytes);
                      if (fileUrl != null) urls.add(fileUrl);
                    }

                    final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                    final success = await profileProvider.setGalleryImages(
                      imageUrls: urls,
                      context: context,
                    );

                    if (success) {
                      setState(() {
                        galleryImages.addAll(urls.map((url) => {
                          "id": null,
                          "url": url.startsWith('http')
                              ? url
                              : 'https://elasticbeanstalk-eu-west-3-838155148197.s3.eu-west-3.amazonaws.com/$url',
                        }));
                        selectedImages.clear();
                        isLoading = false;
                      });

                      final role = context.read<RoleProvider>().role;
                      if (role == UserRole.restaurant) {
                        context.push(Routes.restaurantMenuViewRoute);
                      } else {
                        context.push(Routes.slotManagementViewRoute);
                      }
                    } else {
                      setState(() => isLoading = false);
                    }
                  },
                  buttonWidth: getWidth() * .42,
                  backgroundColor:
                  AppColors.getPrimaryColorFromContext(context),
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  textFontWeight: FontWeight.w700,
                ),
              ],
            ),
            SizedBox(height: getHeightRatio() * 16),
          ],
        ),
      ),
    );
  }
}
