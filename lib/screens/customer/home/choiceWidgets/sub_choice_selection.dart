import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/customWidgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../../../../res/toasts.dart';
import '../../../../routes/routes.dart';
import '../choice_provider.dart';

class SubChoiceSelection extends StatefulWidget {
  final String selectedChoice;

  const SubChoiceSelection({super.key, required this.selectedChoice});

  @override
  _SubChoiceSelectionState createState() => _SubChoiceSelectionState();
}

class _SubChoiceSelectionState extends State<SubChoiceSelection> {
  String searchText = 'Olivia';
  String? selectedRestaurant;
  int? selectedIndex;


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CustomerChoiceProvider>(
        context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final producerType = data?["title"].toLowerCase();
      provider.getProducerPlaces(producerType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final provider = Provider.of<CustomerChoiceProvider>(
        context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(title: al.createChoice),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            _buildSelectedTypeCard(name: data?["title"], icon: data?["icon"]),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child:CustomText(
                text: data?["description"],
                fontFamily: Assets.onsetMedium,
                fontSize: sizes?.fontSize14,
              ),
            ),
            const SizedBox(height: 12),
            CustomField(
              borderColor: AppColors.greyBordersColor,
              hint: _getSearchHint(data?["title"]),
              prefixIconSvg: Assets.searchIcon,
              onChanged: (text) {
                final type = data?["title"].toLowerCase();
                provider.getProducerPlaces(type, query: text.trim().isEmpty ? null : text.trim());
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                // itemCount: filtered.length,
                itemCount:provider.placesResponse. data?.length??0,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final r = provider.placesResponse. data?[index];
                  // final r = filtered[index];
                  final isSelected = selectedRestaurant == r?.name;
                  return ListTile(
                    title:CustomText(
                      text:  r?.name??"nil",
                      fontSize: sizes?.fontSize14,
                    ),
                    subtitle: CustomText(
                      text:r?.address??"nil",
                      fontSize: sizes?.fontSize12,
                    ),
                    trailing: Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    onTap: (){
                      setState(() => selectedRestaurant = r?.name??"nil",);
                      selectedIndex = index;
                    }
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: CustomText(
                      text: al.back,
                      fontFamily: Assets.onsetSemiBold,
                      fontSize: sizes?.fontSize16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedIndex == null) {
                        Toasts.getErrorToast(text: "Please select a producer first.");
                        return;
                      }

                      final selectedPlace = provider.placesResponse.data?[selectedIndex!];
                      if (selectedPlace == null) {
                        Toasts.getErrorToast(text: "Please select a producer first.");
                        return;
                      }
                      context.push(Routes.createChoiceRoute, extra: {
                        "title": data?["title"],
                        "icon": data?["icon"],
                        "description": data?["description"],
                        "placeId":selectedPlace.id,
                        "name": selectedPlace.name,
                        "address": selectedPlace.address,
                        "producerType": data?["title"],
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child:CustomText(
                      text: al.next,
                      fontFamily: Assets.onsetSemiBold,
                      fontSize: sizes?.fontSize16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTypeCard({required String name, required String icon,}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBordersColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SvgPicture.asset(icon,),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:name?? "Restaurant",
                  fontFamily: Assets.onsetMedium,
                  fontSize: sizes?.fontSize14,
                ),

                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: CustomText(
                    text: al.changeType,
                    fontSize: sizes?.fontSize14,
                    fontFamily: Assets.onsetMedium,
                    color: AppColors.userPrimaryColor,
                    textDecoration: TextDecoration.underline,
                    decorationColor: AppColors.userPrimaryColor,
                    giveLinesAsText: true,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => searchText = value),
      controller: TextEditingController(text: searchText),
      decoration: InputDecoration(
        hintText: al.search,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  String _getSearchHint(String? title) {

    switch (title?.toLowerCase()) {
      case 'restaurant':
        return al.searchForRestaurant;
      case 'leisure':
        return al.searchForLeisure;
      case 'wellness':
        return al.searchForWellness;
      default:
        return al.search; // generic fallback
    }
  }

}
