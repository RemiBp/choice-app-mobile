import 'package:choice_app/appColors/colors.dart';
import 'package:choice_app/utilities/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../appAssets/app_assets.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';


class DeleteEventDialog extends StatelessWidget {
  const DeleteEventDialog({super.key, this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.deleteEvent,
                  fontSize: sizes?.fontSize16,
                  fontFamily: Assets.onsetSemiBold,
                  color: AppColors.primarySlateColor,
                ),

                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),

            CustomText(
              text: al.deleteEventConfirmation,
              fontSize: sizes?.fontSize16,
              color: HexColor.fromHex("#4F516D"),
              giveLinesAsText: true,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF2E2F53)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      al.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2E2F53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Your delete logic here
                      onDelete?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5A5F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      al.delete,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
