import 'package:flutter/material.dart';

import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_textfield.dart';
import '../../../../l18n.dart';
import '../../../../res/res.dart';
import '../chat_widgets.dart';
import '../widgets/camera_avatar.dart';

class CreateGroupChatView extends StatefulWidget {
  final List<Map<String, String>> selectedUsers;

  const CreateGroupChatView({super.key, required this.selectedUsers});

  @override
  State<CreateGroupChatView> createState() => _CreateGroupChatViewState();
}

class _CreateGroupChatViewState extends State<CreateGroupChatView> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: ChatAppBar(
        title: al.newGroup,
        showAvatar: false,

        showNextButton: true,
        onNext: () {
          // TODO: Hook create-group flow
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight() * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes!.pagePadding),
              child: Row(
                children: [
                  const CameraAvatar(),
                  SizedBox(width: getWidth() * 0.04),
                  Expanded(
                    child: CustomField(
                      textEditingController: _groupNameController,
                      hint: 'Group name',
                      borderColor: AppColors.greyBordersColor,
                      borderRadius: 12,
                      bgColor: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight() * 0.01),
            SelectedMembersRow(selectedUsers: widget.selectedUsers),
          ],
        ),
      ),
    );
  }
}
