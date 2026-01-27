import 'package:choice_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../onboarding_provider.dart';
import 'menu_widgets.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().fetchMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Menu",
        showEditButton: true,
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          final menuData = provider.menu.map((m) => MenuGroup.fromJson(m)).toList();
          return Container(
            padding: EdgeInsets.symmetric(vertical: getHeight() * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getHeight() * 0.02),
                if (provider.isLoading && provider.menu.isEmpty)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (provider.menu.isEmpty)
                  const Expanded(child: Center(child: CustomText(text: "No categories added yet")))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuData.length,
                      itemBuilder: (context, index) {
                        return MenuGroupWidget(
                          menuGroup: menuData[index],
                          showOption: true,
                          onAddDish: (categoryId) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return AddDishBottomSheet(categoryId: categoryId);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (provider.errorMessage != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                    child: CustomText(
                      text: provider.errorMessage!,
                      color: Colors.red,
                      fontSize: sizes?.fontSize12,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05, vertical: getHeight() * 0.02),
                  child: CustomButton(
                    buttonText: '+ Add Category Title',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const CategoryBottomSheet();
                        },
                      );
                    },
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.getPrimaryColorFromContext(context),
                    textColor: AppColors.getPrimaryColorFromContext(context),
                    textFontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
                  child: Row(
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
                        buttonText: 'Save Changes',
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonWidth: getWidth() * .42,
                        backgroundColor: AppColors.getPrimaryColorFromContext(context),
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        textFontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
