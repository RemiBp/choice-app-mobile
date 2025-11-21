import 'package:choice_app/screens/customer/profile/customer_profile/customer_profile_widget.dart';
import 'package:choice_app/screens/customer/profile/customer_profile_tab_bar/customer_profile_tab_bar.dart';
import 'package:choice_app/screens/leisure/leisure_profile_tab_bar/leisure_profile_tab_bar.dart';
import 'package:choice_app/screens/wellness/wellness_profile_tab_bar/wellness_Profile_tab_bar.dart';
import 'package:choice_app/userRole/user_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../res/res.dart';
import '../../../userRole/role_provider.dart';
import '../../customer/home/home_widgets.dart';
import '../../customer/profile/customer_profile/customer_profile_provider.dart';

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
      itemCount: 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            if(widget.enableOnTap??false){
              if(role == UserRole.user){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerProfileTabBar()),
                );
              }
              else if(role == UserRole.restaurant || role == UserRole.leisure){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeisureProfileTabBar()),
                );
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WellnessProfileTabBar()),
                );
              }
            }
          },
          child: PostCard(),
        );
      },
    );
  }
}





