import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../customer/home/home_widgets.dart';
import '../home/producer_post_provider.dart';
import '../../../res/res.dart';

class RestaurantPostsView extends StatefulWidget {
  const RestaurantPostsView({super.key});

  @override
  State<RestaurantPostsView> createState() => _RestaurantPostsViewState();
}

class _RestaurantPostsViewState extends State<RestaurantPostsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProducerPostProvider>().fetchMyPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProducerPostProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null && provider.posts.isEmpty) {
          return Center(child: Text(provider.errorMessage!));
        }

        if (provider.posts.isEmpty) {
          return const Center(child: Text("No posts yet"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
          itemCount: provider.posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: provider.posts[index]);
          },
        );
      },
    );
  }
}
