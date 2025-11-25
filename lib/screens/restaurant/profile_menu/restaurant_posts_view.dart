import 'package:choice_app/screens/restaurant/home/choice_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../res/res.dart';
import '../../customer/home/home_widgets.dart';

class RestaurantPostsView extends StatefulWidget {
  const RestaurantPostsView({super.key});

  @override
  State<RestaurantPostsView> createState() => _RestaurantPostsViewState();
}

class _RestaurantPostsViewState extends State<RestaurantPostsView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChoiceProvider>(context,listen: false);
    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding
      ),
      itemCount:provider.postsResponse.data?.length??0,
      itemBuilder: (context, index) {
        return PostCard(index: index);
      },
    );
  }
}