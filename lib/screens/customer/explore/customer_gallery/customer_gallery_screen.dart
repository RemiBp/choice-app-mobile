import 'package:choice_app/appColors/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../customWidgets/common_app_bar.dart';

class ImageGalleryScreen extends StatefulWidget {
  final String restaurantId;

  const ImageGalleryScreen({super.key, required this.restaurantId});

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  // ✅ Dummy image list
  final List<String> dummyImages = [
    "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
    "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
    "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
    "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
    "https://images.unsplash.com/photo-1551218808-94e220e084d2",
    "https://images.unsplash.com/photo-1546069901-eacef0df6022",
    "https://images.unsplash.com/photo-1551782450-a2132b4ba21d",
    "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: "Gallery"),
      body: dummyImages.isNotEmpty
          ? GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          crossAxisCount: 2,
        ),
        itemCount: dummyImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push('/image_viewer', extra: {
                'images': dummyImages,
                'initialIndex': index,
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: dummyImages[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text("Nothing to show"),
      ),
    );
  }
}

/// Simple fullscreen preview
class FullscreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullscreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
