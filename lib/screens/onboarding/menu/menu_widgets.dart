import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/custom_textfield.dart';
import '../../../res/res.dart';
import '../onboarding_provider.dart';

class MenuGroupWidget extends StatelessWidget {
  final MenuGroup menuGroup;
  final Function(int categoryId) onAddDish;
  final bool? showOption;
  final bool? hideBorder;
  final String? optionText;
  final String? header;

  const MenuGroupWidget({
    super.key,
    required this.menuGroup,
    required this.onAddDish,
    this.hideBorder,
    this.showOption,
    this.optionText,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: showOption ?? false ? EdgeInsets.symmetric(horizontal: getWidth() * 0.05) : EdgeInsets.zero,
          child: Row(
            children: [
              CustomText(
                text: header ?? '${menuGroup.title} (${menuGroup.dishes.length})',
                fontSize: sizes?.fontSize16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              const Spacer(),
              if (showOption ?? false)
                Icon(Icons.add, color: AppColors.getPrimaryColorFromContext(context)),
              SizedBox(width: getWidth() * 0.01),
              GestureDetector(
                onTap: () => onAddDish(menuGroup.id),
                child: CustomText(
                  text: optionText ?? 'Add Dish',
                  fontSize: sizes?.fontSize14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getPrimaryColorFromContext(context),
                ),
              ),
            ],
          ),
        ),
        ...menuGroup.dishes.map((dish) => DishItemWidget(dish: dish, showOption: showOption)),
        if (!(hideBorder ?? false)) Divider(height: getHeight() * 0.03),
      ],
    );
  }
}

class DishItemWidget extends StatelessWidget {
  final Dish dish;
  final bool? showOption;

  const DishItemWidget({super.key, required this.dish, this.showOption});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: showOption ?? false ? EdgeInsets.only(left: getWidth() * 0.05) : EdgeInsets.zero,
      title: CustomText(
        text: dish.name,
        fontSize: sizes?.fontSize14,
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      subtitle: CustomText(
        text: dish.description,
        fontSize: sizes?.fontSize12,
        fontWeight: FontWeight.w400,
        color: AppColors.primarySlateColor,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: '\$${dish.price}',
            fontSize: sizes?.fontSize14,
            fontWeight: FontWeight.w400,
            color: AppColors.blackColor,
          ),
          if (showOption ?? false) SizedBox(width: sizes!.pagePadding),
          if (showOption ?? false)
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert),
              color: AppColors.whiteColor,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 18),
                      const SizedBox(width: 8),
                      CustomText(
                        text: 'Edit',
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      CustomText(
                        text: 'Delete',
                        fontSize: sizes?.fontSize14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.redColor,
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Future implementation: handle edit/delete
              },
            ),
        ],
      ),
    );
  }
}

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({super.key});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: sizes!.pagePadding,
            vertical: getHeight() * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: getWidth() * 0.25,
                    height: getHeight() * 0.006,
                    decoration: BoxDecoration(
                      color: AppColors.greyBordersColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: getHeight() * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Add Category Title',
                      fontSize: sizes?.fontSize18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: AppColors.primarySlateColor),
                    ),
                  ],
                ),
                SizedBox(height: getHeight() * 0.03),
                CustomField(
                  controller: _titleController,
                  borderColor: AppColors.greyBordersColor,
                  hint: "E.g: Eat Day, Main Menu, Specials...",
                  label: "Category Title",
                ),
                SizedBox(height: getHeight() * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      buttonText: 'Cancel',
                      onTap: () => Navigator.pop(context),
                      buttonWidth: getWidth() * .42,
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.blackColor,
                      textColor: AppColors.blackColor,
                      textFontWeight: FontWeight.w700,
                    ),
                    CustomButton(
                      buttonText: provider.isLoading ? 'Saving...' : 'Save',
                      onTap: provider.isLoading || _titleController.text.isEmpty
                          ? null
                          : () async {
                              final success = await provider.addMenuCategory(_titleController.text);
                              if (success && mounted) {
                                Navigator.pop(context);
                              }
                            },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: provider.isLoading || _titleController.text.isEmpty 
                        ? AppColors.textGreyColor 
                        : AppColors.getPrimaryColorFromContext(context),
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      textFontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddDishBottomSheet extends StatefulWidget {
  final int categoryId;
  const AddDishBottomSheet({super.key, required this.categoryId});

  @override
  State<AddDishBottomSheet> createState() => _AddDishBottomSheetState();
}

class _AddDishBottomSheetState extends State<AddDishBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizes!.pagePadding,
          vertical: getHeight() * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: getWidth() * 0.25,
                  height: getHeight() * 0.006,
                  decoration: BoxDecoration(
                    color: AppColors.greyBordersColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: getHeight() * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Add Dish',
                    fontSize: sizes?.fontSize18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.primarySlateColor),
                  ),
                ],
              ),
              SizedBox(height: getHeight() * 0.03),
              CustomField(
                controller: _nameController,
                borderColor: AppColors.greyBordersColor,
                hint: "E.g: Brochette boeuf...",
                label: "Dish Name",
              ),
              SizedBox(height: getHeight() * 0.02),
              CustomField(
                controller: _priceController,
                borderColor: AppColors.greyBordersColor,
                hint: "E.g: \$0.00",
                label: "Price",
                textInputType: TextInputType.number,
              ),
              SizedBox(height: getHeight() * 0.02),
              CustomField(
                controller: _descController,
                height: getHeight() * .1,
                borderColor: AppColors.greyBordersColor,
                hint: "Brief description of the dish...",
                label: "Description (Optional)",
              ),
              SizedBox(height: getHeight() * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonText: 'Cancel',
                    onTap: () => Navigator.pop(context),
                    buttonWidth: getWidth() * .42,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.blackColor,
                    textColor: AppColors.blackColor,
                    textFontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    buttonText: provider.isLoading ? 'Saving...' : 'Save',
                    onTap: provider.isLoading || _nameController.text.isEmpty || _priceController.text.isEmpty
                        ? null
                        : () async {
                            final success = await provider.addMenuDish(
                              name: _nameController.text,
                              price: double.tryParse(_priceController.text) ?? 0.0,
                              categoryId: widget.categoryId,
                              description: _descController.text,
                            );
                            if (success && mounted) {
                              Navigator.pop(context);
                            }
                          },
                    buttonWidth: getWidth() * .42,
                    backgroundColor: provider.isLoading || _nameController.text.isEmpty || _priceController.text.isEmpty
                      ? AppColors.textGreyColor 
                       : AppColors.getPrimaryColorFromContext(context),
                    borderColor: Colors.transparent,
                    textColor: Colors.white,
                    textFontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuGroup {
  final int id;
  final String title;
  final List<Dish> dishes;

  MenuGroup({required this.id, required this.title, required this.dishes});

  factory MenuGroup.fromJson(Map<String, dynamic> json) {
    return MenuGroup(
      id: json['id'],
      title: json['name'],
      dishes: (json['dishes'] as List? ?? []).map((d) => Dish.fromJson(d)).toList(),
    );
  }
}

class Dish {
  final int id;
  final String name;
  final String description;
  final double price;

  Dish({required this.id, required this.name, required this.description, required this.price});

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}