import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/data/models/cuisine_type.dart';
import 'package:choice_app/screens/onboarding/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:choice_app/customWidgets/animations/fade_in_up.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_drop_down.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/text_field_label.dart';
import '../../../res/res.dart';

class AddCuisine extends StatefulWidget {
  const AddCuisine({super.key});

  @override
  State<AddCuisine> createState() => _AddCuisineState();
}

class _AddCuisineState extends State<AddCuisine> {
  int? selectedCuisineId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().fetchCuisineTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Cuisine",
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizes!.pagePadding,
              vertical: getHeight() * .02,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getHeight() * 0.01),
                  const TextFieldLabel(
                    label: "Cuisine Type",
                  ),
                  provider.isLoading && provider.cuisineTypes.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : CustomDropdown(
                          items: provider.cuisineTypes.map((c) {
                            return DropdownMenuItem<int>(
                              value: c.id,
                              child: CustomText(
                                text: c.name,
                                fontWeight: FontWeight.w400,
                                fontSize: sizes?.fontSize16,
                                lines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          selectedValue: selectedCuisineId,
                          hintText: 'Select cuisine type',
                          onChanged: (id) {
                            setState(() {
                              selectedCuisineId = id;
                            });
                          },
                          validator: (id) => id == null ? 'Please select cuisine type' : null,
                        ),
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    CustomText(
                      text: provider.errorMessage!,
                      color: Colors.red,
                      fontSize: sizes?.fontSize12,
                    ),
                  ],
                  const Spacer(),
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
                        buttonText: provider.isLoading ? 'Saving...' : 'Save Changes',
                        onTap: selectedCuisineId == null || provider.isLoading
                            ? null
                            : () async {
                                final success = await provider.saveCuisineType(selectedCuisineId!);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Cuisine updated successfully")),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                        buttonWidth: getWidth() * .42,
                        backgroundColor: (selectedCuisineId == null || provider.isLoading)
                            ? AppColors.textGreyColor
                            : AppColors.getPrimaryColorFromContext(context),
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        textFontWeight: FontWeight.w700,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
