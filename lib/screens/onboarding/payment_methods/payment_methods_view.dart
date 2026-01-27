
import 'package:choice_app/customWidgets/custom_button.dart';
import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../appAssets/app_assets.dart';
import '../../../appColors/colors.dart';
import '../../../customWidgets/common_app_bar.dart';
import '../onboarding_provider.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key});

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  // Local state to track selections before saving
  final Set<int> _selectedMethodIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OnboardingProvider>();
      provider.fetchPaymentMethods().then((_) {
        // Initialize local state from provider data
        final methods = provider.paymentMethods;
        setState(() {
          _selectedMethodIds.clear();
          for (var method in methods) {
            if (method['isSelected'] == true) {
              _selectedMethodIds.add(method['id']);
            }
          }
        });
      });
    });
  }

  void _onSave() async {
    final provider = context.read<OnboardingProvider>();
    final success = await provider.savePaymentMethods(_selectedMethodIds.toList());
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment methods saved successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(title: "Payment Methods"),
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.paymentMethods.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.restaurantPrimaryColor));
          }

          final methods = provider.paymentMethods;

          if (methods.isEmpty) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const CustomText(text: "No payment methods available"),
                   TextButton(onPressed: provider.fetchPaymentMethods, child: const Text("Retry"))
                 ],
               ),
             );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding, vertical: getHeightRatio() * 20),
                  itemCount: methods.length,
                  separatorBuilder: (context, index) => SizedBox(height: getHeightRatio() * 12),
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    final int id = method['id'];
                    final String name = method['name'] ?? "Unknown";
                    final bool isSelected = _selectedMethodIds.contains(id);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedMethodIds.remove(id);
                          } else {
                            _selectedMethodIds.add(id);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(getHeightRatio() * 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.restaurantPrimaryColor.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.restaurantPrimaryColor : AppColors.greyBordersColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // You might want to map names to Icons here if possible
                            Icon(
                              _getIconForMethod(name),
                              color: isSelected ? AppColors.restaurantPrimaryColor : AppColors.textGreyColor,
                            ),
                            SizedBox(width: getWidthRatio() * 16),
                            Expanded(
                              child: CustomText(
                                text: name,
                                fontSize: sizes?.fontSize16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? AppColors.blackColor : AppColors.primarySlateColor,
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.restaurantPrimaryColor),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(sizes!.pagePadding),
                child: CustomButton(
                  buttonText: "Save Changes",
                  isLoading: provider.isLoading,
                  onTap: _onSave,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getIconForMethod(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('card') || lower.contains('visa') || lower.contains('master')) return Icons.credit_card;
    if (lower.contains('cash')) return Icons.money;
    if (lower.contains('apple')) return Icons.apple; // Requires specific icon or FontAwesome
    if (lower.contains('google')) return Icons.android;
    if (lower.contains('wallet')) return Icons.account_balance_wallet;
    return Icons.payment;
  }
}
