import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../../../customWidgets/custom_button.dart';
import '../../../customWidgets/custom_text.dart';
import '../../../customWidgets/multiple_selection_dropdown.dart';
import '../../../customWidgets/text_field_label.dart';
import '../../../res/res.dart';
import '../../../data/models/cuisine_type.dart';
import '../onboarding_provider.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  List<CuisineType> selectedServices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().fetchServiceTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: "Services",
      ),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizes!.pagePadding,
              vertical: getHeight() * .02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getHeight() * 0.01),
                const TextFieldLabel(
                  label: "Services Type",
                ),
                provider.isLoading && provider.serviceTypes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : MultiSelectDropdown(
                        options: provider.serviceTypes,
                        selectedItems: selectedServices,
                        hintText: 'Select services type',
                        onSelectionChanged: (updatedList) {
                          setState(() {
                            selectedServices = updatedList;
                          });
                        },
                      ),
                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  CustomText(
                    text: provider.errorMessage!,
                    color: Colors.red,
                    fontSize: sizes?.fontSize12,
                  ),
                ],
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Wrap(
                        spacing: getWidth() * 0.02,
                        runSpacing: 0,
                        children: selectedServices.map((service) {
                          return Chip(
                            deleteIcon: const Icon(Icons.close),
                            deleteIconColor: AppColors.blackColor,
                            backgroundColor: AppColors.greyBordersColor,
                            label: CustomText(
                              text: service.name,
                              fontWeight: FontWeight.w400,
                              fontSize: sizes?.fontSize12,
                              color: AppColors.blackColor,
                            ),
                            onDeleted: () {
                              setState(() {
                                selectedServices.remove(service);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getHeight() * 0.02),
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
                      onTap: selectedServices.isEmpty || provider.isLoading
                          ? null
                          : () async {
                              final ids = selectedServices.map((s) => s.id).toList();
                              final success = await provider.saveServiceTypes(ids);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Services updated successfully")),
                                );
                                Navigator.pop(context);
                              }
                            },
                      buttonWidth: getWidth() * .42,
                      backgroundColor: (selectedServices.isEmpty || provider.isLoading)
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
          );
        },
      ),
    );
  }
}
