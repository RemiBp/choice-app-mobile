import 'package:choice_app/customWidgets/custom_text.dart';
import 'package:choice_app/data/models/cuisine_type.dart';
import 'package:flutter/material.dart';
import '../appAssets/app_assets.dart';
import '../appColors/colors.dart';
import '../res/res.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<CuisineType> options;
  final List<CuisineType> selectedItems;
  final ValueChanged<List<CuisineType>> onSelectionChanged;
  final String hintText;

  const MultiSelectDropdown({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.hintText = 'Select services type',
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  late List<CuisineType> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _tempSelectedItems = List.from(widget.selectedItems); // fresh copy
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox box = context.findRenderObject() as RenderBox;
    Size size = box.size;
    Offset offset = box.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              left: offset.dx,
              top: offset.dy + size.height + 8,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withAlpha(20),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: StatefulBuilder(
                      builder: (context, setInnerState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            SizedBox(
                              height: 200, // You can adjust this as needed
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: widget.options.length,
                                itemBuilder: (context, index) {
                                  final item = widget.options[index];
                                  final isSelected = _tempSelectedItems.contains(item);

                                  return InkWell(
                                    onTap: () {
                                      setInnerState(() {
                                        if (isSelected) {
                                          _tempSelectedItems.remove(item);
                                        } else {
                                          _tempSelectedItems.add(item);
                                        }
                                      });
                                      widget.onSelectionChanged(List.from(_tempSelectedItems));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              text: item.name,
                                              fontSize: sizes?.fontSize14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: isSelected
                                                ? AppColors.getPrimaryColorFromContext(context)
                                                : AppColors.inputHintColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),


                            // ...widget.options.map((item) {
                            //   final isSelected = _tempSelectedItems.contains(item);
                            //   return InkWell(
                            //     onTap: () {
                            //       setInnerState(() {
                            //         if (isSelected) {
                            //           _tempSelectedItems.remove(item);
                            //         } else {
                            //           _tempSelectedItems.add(item);
                            //         }
                            //       });
                            //       // Notify parent
                            //       widget.onSelectionChanged(List.from(_tempSelectedItems));
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Expanded(
                            //               child: CustomText(
                            //                   text: item.name,
                            //                 fontSize: sizes?.fontSize14,
                            //                 fontWeight: FontWeight.w500,
                            //                 color: AppColors.blackColor,
                            //               )
                            //               // Text(item.name),
                            //           ),
                            //           Icon(
                            //             isSelected
                            //                 ? Icons.check_circle
                            //                 : Icons.radio_button_unchecked,
                            //             color: isSelected ? AppColors.getPrimaryColorFromContext(context) : AppColors.inputHintColor,
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   );
                            // }),
                            const Divider(),
                            TextButton(
                              onPressed: _removeOverlay,
                              child: CustomText(
                                  text: "Done",
                                fontSize: sizes?.fontSize14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.getPrimaryColorFromContext(context),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedItems.isEmpty
                      ? widget.hintText
                      : '${widget.selectedItems.length} selected',
                  style: TextStyle(
                    color: widget.selectedItems.isEmpty ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// class MultiSelectDropdown extends StatelessWidget {
//   final List<CuisineType> options;
//   final List<CuisineType> selectedItems;
//   final ValueChanged<List<CuisineType>> onSelectionChanged;
//   final String hintText;
//
//   const MultiSelectDropdown({
//     super.key,
//     required this.options,
//     required this.selectedItems,
//     required this.onSelectionChanged,
//     this.hintText = 'Select services type',
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<CuisineType>(
//       position: PopupMenuPosition.under,
//       itemBuilder: (context) {
//         return options.map((cuisine) {
//           final isSelected = selectedItems.contains(cuisine);
//           return PopupMenuItem<CuisineType>(
//             value: cuisine,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(child: Text(cuisine.name, overflow: TextOverflow.ellipsis)),
//                 Icon(
//                   isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
//                   color: isSelected ? Colors.green : Colors.grey,
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//       onSelected: (cuisine) {
//         final updatedList = [...selectedItems];
//         if (updatedList.contains(cuisine)) {
//           updatedList.remove(cuisine);
//         } else {
//           updatedList.add(cuisine);
//         }
//         onSelectionChanged(updatedList); // Call parent with updated list
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: getWidthRatio() * 16,
//           vertical: getHeightRatio() * 14,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.greyBordersColor),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 selectedItems.isEmpty
//                     ? hintText
//                     : '${selectedItems.length} selected',
//                 style: TextStyle(
//                   fontFamily: Assets.onsetRegular,
//                   fontSize: sizes?.fontSize16,
//                   color: selectedItems.isEmpty
//                       ? AppColors.inputHintColor
//                       : Colors.black,
//                 ),
//               ),
//             ),
//             Icon(Icons.keyboard_arrow_down,
//                 color: AppColors.inputHintColor, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }

