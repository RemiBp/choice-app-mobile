import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../customer/home/home_widgets.dart';

class RestaurantChoiceView extends StatefulWidget {
  final bool? enableOnTap;
  const RestaurantChoiceView({super.key, this.enableOnTap});

  @override
  State<RestaurantChoiceView> createState() => _RestaurantChoiceViewState();
}

class _RestaurantChoiceViewState extends State<RestaurantChoiceView> {

  @override
  Widget build(BuildContext context) {
    final role = context.read<RoleProvider>().role;
    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (widget.enableOnTap ?? false) {
              if (role == UserRole.user) {
                context.push('/customer_profile_tab');
              } else if (role == UserRole.restaurant ||
                  role == UserRole.leisure) {
                context.push('/leisure_profile_tab');
              } else {
                context.push('/wellness_profile_tab');
              }
            }
          },
          child: PostCard(),
        );
      },
    );
  }
}

