import 'package:flutter/material.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/common_app_bar.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../onboarding/menu/menu_widgets.dart';

class FullMenuView extends StatefulWidget {
  final List<MenuGroup> menuGroups;
  const FullMenuView({super.key, required this.menuGroups,});

  @override
  State<FullMenuView> createState() => _FullMenuViewState();
}

class _FullMenuViewState extends State<FullMenuView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.menu),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: getHeight() * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.menuGroups.length,
                padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
                itemBuilder: (context, index) {
                  return MenuGroupWithoutOptionWidget(
                    menuGroup: widget.menuGroups[index],
                    showOption: false,
                    hideBorder: true,
                    header: widget.menuGroups[index].title,
                    onAddDish: (){},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
