import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../appAssets/app_assets.dart';
import '../../../../appColors/colors.dart';
import '../../../../customWidgets/custom_button.dart';
import '../../../../customWidgets/custom_text.dart';
import '../../../../res/res.dart';
import '../../customWidgets/custom_textfield.dart';
import '../../l18n.dart';
import '../../res/toasts.dart';
import '../../utilities/extensions.dart';
import '../customer/interested/interestedWidgets/time_slot_widgets.dart';
import '../restaurant/profile/profile_provider.dart';
import 'offer_provider.dart';

class OfferTemplateBottomSheet extends StatefulWidget {
  const OfferTemplateBottomSheet({super.key});

  @override
  State<OfferTemplateBottomSheet> createState() =>
      _OfferTemplateBottomSheetState();
}

class _OfferTemplateBottomSheetState extends State<OfferTemplateBottomSheet> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final templates = context.watch<TemplateProvider>().templates;
    final hasOffers = templates.isNotEmpty;

    return SafeArea(
      top: false,
      child: Container(
        // Dynamically adjust height
        height: hasOffers ? getHeight() * 0.55 : null,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.06, vertical: getHeight() * 0.02),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gray bar
            Container(
              margin: EdgeInsets.only(bottom: getHeight() * 0.015),
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: al.offerTemplate,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: Assets.onsetSemiBold,
                ),
                Row(
                  children: [
                    if (hasOffers)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const TargetedNotificationBottomSheet(),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add,
                                size: 18,
                                color: AppColors.getPrimaryColorFromContext(context)),
                            SizedBox(width: getWidth() * 0.01),
                            CustomText(
                              text: al.createOffer,
                              fontSize: 13,
                              color: AppColors.getPrimaryColorFromContext(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    if (hasOffers) SizedBox(width: getWidth() * 0.04),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: getHeight() * 0.02),

            // Body
            if (hasOffers)
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildTemplateList(context, templates)),
                    SizedBox(height: getHeight() * 0.015),
                    CustomButton(
                      buttonText: al.continueText,
                      onTap: selectedIndex != null
                          ? () {
                        final selectedTemplate = templates[selectedIndex!];

                        Navigator.pop(context); // close the template selection sheet

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => TargetedNotificationBottomSheet(
                            templateToEdit: selectedTemplate, // pass the selected template
                          ),
                        );
                      }
                          : null,
                      backgroundColor: selectedIndex != null
                          ? AppColors.getPrimaryColorFromContext(context)
                          : Colors.grey.shade400,
                      borderColor: selectedIndex != null
                          ? AppColors.getPrimaryColorFromContext(context)
                          : Colors.grey.shade400,
                    ),
                    SizedBox(height: getHeight() * 0.02),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(bottom: getHeight() * 0.01),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: getWidth() * 0.21,
                      width: getWidth() * 0.21,
                      decoration: BoxDecoration(
                        color: AppColors.getPrimaryColorFromContext(context)
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.folderIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.getPrimaryColorFromContext(context),
                            BlendMode.srcIn,
                          ),
                          height: getWidth() * 0.125,
                          width: getWidth() * 0.125,
                        ),
                      ),
                    ),
                    SizedBox(height: getHeight() * 0.02),
                    CustomText(
                      text: al.noTemplateYet,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: Assets.onsetSemiBold,
                    ),
                    SizedBox(height: getHeight() * 0.005),
                    CustomText(
                      text:
                      al.templateInfo,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      fontFamily: Assets.onsetMedium,
                      giveLinesAsText: true,
                    ),
                    SizedBox(height: getHeight() * 0.03),
                    CustomButton(
                      buttonText: al.createOffer,
                      backgroundColor: AppColors.getPrimaryColorFromContext(context),
                      borderColor: AppColors.getPrimaryColorFromContext(context),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const TargetedNotificationBottomSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Empty State (no offers yet)

  Widget _buildEmptyBody(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: getWidth() * 0.21,
            width: getWidth() * 0.21,
            decoration: BoxDecoration(
              color: AppColors.getPrimaryColorFromContext(context)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.folderIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.getPrimaryColorFromContext(context),
                  BlendMode.srcIn,
                ),
                height: getWidth() * 0.125,
                width: getWidth() * 0.125,
              ),
            ),
          ),
          SizedBox(height: getHeight() * 0.02),
          CustomText(
            text: al.noTemplateYet,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: Assets.onsetSemiBold,
          ),
          SizedBox(height: getHeight() * 0.005),
          CustomText(
            text:
            al.templateInfo,
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
            fontFamily: Assets.onsetMedium,
            giveLinesAsText: true,
          ),
          const Spacer(),
          CustomButton(
            buttonText: al.createOffer,
            backgroundColor: AppColors.getPrimaryColorFromContext(context),
            borderColor: AppColors.getPrimaryColorFromContext(context),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const TargetedNotificationBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  //  Saved Offers List
  Widget _buildTemplateList(BuildContext context, List<Template> templates) {
    return ListView.builder(
      itemCount: templates.length,
      padding: EdgeInsets.only(bottom: getHeight() * 0.02),
      itemBuilder: (context, index) {
        final t = templates[index];
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedIndex == index) {
                selectedIndex = null; // unselect
              } else {
                selectedIndex = index;
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: getHeight() * 0.015),
            padding: EdgeInsets.all(getWidth() * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                SvgPicture.asset(
                  Assets.offerIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.getPrimaryColorFromContext(context),
                    BlendMode.srcIn,
                  ),
                  height: getWidth() * 0.07,
                  width: getWidth() * 0.07,
                ),
                SizedBox(width: getWidth() * 0.03),

                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: t.title,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: Assets.onsetMedium,
                      ),
                      SizedBox(height: getHeight() * 0.006),
                      CustomText(
                        text: "${t.reduction}% OFF - ${t.message}",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: Assets.onsetRegular,
                      ),
                    ],
                  ),
                ),

                // Radio button
                Radio<int?>(
                  value: index,
                  groupValue: selectedIndex,
                  activeColor: AppColors.getPrimaryColorFromContext(context),
                  onChanged: (val) {
                    setState(() {
                      if (selectedIndex == val) {
                        selectedIndex = null;
                      } else {
                        selectedIndex = val;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class TargetedNotificationBottomSheet extends StatelessWidget {
  final Template? templateToEdit;
  const TargetedNotificationBottomSheet({super.key,this.templateToEdit});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController(text: templateToEdit?.title ?? '');
    final msg = TextEditingController(text: templateToEdit?.message ?? '');
    final reduction = TextEditingController(
        text: templateToEdit != null ? templateToEdit!.reduction.toString() : ''
    );
    final validate = TextEditingController(
        text: templateToEdit?.validityMinutes.toString() ?? '');
    final users = TextEditingController(
        text: templateToEdit?.maxRecipients.toString() ?? '');
    final distance = TextEditingController(
        text: templateToEdit?.radiusMeters.toString() ?? '');

    Widget label(String text) => RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: getWidth() * 0.034,
          fontFamily: Assets.onsetSemiBold,
        ),
        children: const [
          TextSpan(text: " *", style: TextStyle(color: Colors.red)),
        ],
      ),
    );

    Widget field(String labelText, TextEditingController ctrl, String hint,
        {bool isMsg = false}) {
      return Padding(
        padding: EdgeInsets.only(bottom: getHeight() * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label(labelText),
            SizedBox(height: 6),
            isMsg
                ? MessageField(
              controller: ctrl,
              hintText: hint,
              backgroundColor: AppColors.whiteColor,
              borderColor: AppColors.inputHintColor
            )
                : CustomField2(
              textEditingController: ctrl,
              borderColor: AppColors.greyBordersColor,
              hint: hint,
              label: null,
              bgColor: AppColors.whiteColor,
            ),
          ],
        ),
      );
    }

    return Padding(
      // this gives your bottom sheet space to move up when the keyboard opens
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.95, // almost full screen (like your draggable sheet)
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth() * 0.05),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight() * 0.02),

                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: al.targetedNotification,
                        fontWeight: FontWeight.w600,
                        fontFamily: Assets.onsetSemiBold,
                        fontSize: 16,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  CustomText(
                    text: al.step1WriteOffer,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: getHeight() * 0.025),

                  // Fields
                  field(al.title, title, "e.g: Flash Offer"),
                  field(al.message, msg, al.exampleOffer, isMsg: true),
                  field(al.reductionPercent, reduction, "e.g: 15"),
                  Padding(
                    padding: EdgeInsets.only(bottom: getHeight() * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(al.validateMinutes),
                        const SizedBox(height: 6),
                        IncrementSelector(
                          controller: validate,
                          step: 30,
                          unit: ' min',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: getHeight() * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(al.numberOfUsers),
                        const SizedBox(height: 6),
                        IncrementSelector(
                          controller: users,
                          step: 10,
                          unit: ' persons'
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: getHeight() * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(al.distance),
                        const SizedBox(height: 6),
                        IncrementSelector(
                          controller: distance,
                          step: 100,
                          unit: 'm',
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: getHeight() * 0.03),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          buttonText: al.cancel,
                          onTap: () => Navigator.pop(context),
                          backgroundColor: Colors.transparent,
                          borderColor: AppColors.blackColor,
                          textColor: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: getWidth() * 0.04),
                      Expanded(
                        child: CustomButton(
                          buttonText: al.next,
                            onTap: () async {
                              final t = title.text.trim();
                              final m = msg.text.trim();

                              final discount = int.tryParse(reduction.text.trim());
                              final minutes = int.tryParse(validate.text.replaceAll('min', '').trim());
                              final recipients = int.tryParse(users.text.replaceAll('persons','').trim());
                              final radius = int.tryParse(distance.text.replaceAll('m', '').trim());

                              // ✅ VALIDATIONS + TOAST
                              if (t.isEmpty) {
                                Toasts.getErrorToast(text: "Offer title is required");
                                return;
                              }
                              if (m.isEmpty) {
                                Toasts.getErrorToast(text: "Offer message is required");
                                return;
                              }
                              if (discount == null || discount <= 0 || discount > 100) {
                                Toasts.getErrorToast(text: "Discount must be between 1–100%");
                                return;
                              }
                              if (minutes == null || minutes < 30) {
                                Toasts.getErrorToast(text: "Validity must be at least 30 minutes");
                                return;
                              }
                              if (recipients == null || recipients <= 0) {
                                Toasts.getErrorToast(text: "Users must be greater than 0");
                                return;
                              }
                              if (radius == null || radius < 100) {
                                Toasts.getErrorToast(text: "Distance must be at least 100m");
                                return;
                              }

                              // GET PRODUCER ID
                              final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                              final profile = await profileProvider.getProducerProfile();
                              final producerId = profile?.producer?.id;
                              final producerLong = profile?.producer?.longitude;
                              final producerLat = profile?.producer?.latitude;

                              if (producerId == null) {
                                Toasts.getErrorToast(text: "Unable to fetch producer ID");
                                return;
                              }
                              if (producerLong == null) {
                                Toasts.getErrorToast(text: "Unable to fetch producer longitude");
                                return;
                              }
                              if (producerLat == null) {
                                Toasts.getErrorToast(text: "Unable to fetch producer latitude");
                                return;
                              }

                              //  All checks passed, send to preview
                              final data = TargetedNotificationData(
                                offerId: templateToEdit?.offerId,
                                title: t,
                                message: m,
                                reduction: discount,
                                validityMinutes: minutes,
                                maxRecipients: recipients,
                                radiusMeters: radius,
                              );

                              Navigator.pop(context);

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => TargetedNotificationPreviewSheet(
                                  data: data,
                                  producerId: producerId,
                                  producerLong: producerLong,
                                  producerLat: producerLat,
                                ),
                              );
                            },
                          backgroundColor:
                          AppColors.getPrimaryColorFromContext(context),
                          borderColor:
                          AppColors.getPrimaryColorFromContext(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TargetedNotificationData {
  final int? offerId;
  final String title;
  final String message;
  final int reduction;
  final int validityMinutes;
  final int maxRecipients;
  final int radiusMeters;

  TargetedNotificationData({
    this.offerId,
    required this.title,
    required this.message,
    required this.reduction,
    required this.validityMinutes,
    required this.maxRecipients,
    required this.radiusMeters,
  });
}


class TargetedNotificationPreviewSheet extends StatefulWidget {
  final TargetedNotificationData data;
  final int producerId;
  final String producerLong;
  final String producerLat;
  const TargetedNotificationPreviewSheet({
    super.key,
    required this.data,
    required this.producerId,
    required this.producerLat,
    required this.producerLong
  });

  @override
  State<TargetedNotificationPreviewSheet> createState() =>
      _TargetedNotificationPreviewSheetState();
}

class _TargetedNotificationPreviewSheetState
    extends State<TargetedNotificationPreviewSheet> {
  bool saveTemplate = false;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 342,
          maxHeight: maxHeight, // prevent overflow on small screens
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.whiteColor,
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getWidth() * 0.05,
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flexible area for scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === HEADER ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: al.targetedNotification,
                              fontWeight: FontWeight.w600,
                              fontFamily: Assets.onsetSemiBold,
                              fontSize: 16,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close, size: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: getHeight() * 0.006),
                        CustomText(
                          text: al.step2ChooseTarget,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: Assets.onsetRegular,
                        ),
                        SizedBox(height: getHeight() * 0.025),

                        // CARD 1
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(getWidth() * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryColorFromContext(context)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.groupIcon,
                                width: getWidth() * 0.064,
                                height: getHeight() * 0.0295,
                                colorFilter: ColorFilter.mode(
                                  AppColors.getPrimaryColorFromContext(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: getWidth() * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: al.allNearbyUsers,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: Assets.onsetMedium,
                                    ),
                                    CustomText(
                                      text: al.allActiveUsers,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: Assets.onsetRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: getHeight() * 0.025),

                        // ESTIMATED USERS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.groupIcon,
                                  width: getWidth() * 0.045,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.inputHintColor,
                                    BlendMode.srcIn,
                                  ),
                                  height: getHeight() * 0.02,
                                ),
                                SizedBox(width: getWidth() * 0.015),
                                CustomText(
                                  text: al.estimated,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Assets.onsetRegular,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            CustomText(
                              text: "0 ${al.onlineUsers}",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: Assets.onsetRegular,
                            ),
                          ],
                        ),

                        SizedBox(height: getHeight() * 0.025),

                        CustomText(
                          text: al.notificationAppearance,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: Assets.onsetMedium,
                        ),
                        SizedBox(height: getHeight() * 0.012),

                        // CARD 2
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(getWidth() * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.getPrimaryColorFromContext(context)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                              AppColors.getPrimaryColorFromContext(context),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.offerIcon,
                                width: getWidth() * 0.085,
                                height: getHeight() * 0.039,
                                colorFilter: ColorFilter.mode(
                                  AppColors.getPrimaryColorFromContext(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: getWidth() * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "${widget.data.reduction}%",
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Assets.onsetSemiBold,
                                      fontSize: 24,
                                    ),
                                    CustomText(
                                      text: widget.data.title,
                                      fontFamily: Assets.onsetMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    CustomText(
                                      text: widget.data.message,
                                      fontFamily: Assets.onsetRegular,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: getHeight() * 0.02),

                        // === CHECKBOX ===
                        Row(
                          children: [
                            Checkbox(
                              value: saveTemplate,
                              onChanged: (val) =>
                                  setState(() => saveTemplate = val ?? false),
                              activeColor:
                              AppColors.getPrimaryColorFromContext(context),
                            ),
                            CustomText(
                              text: al.saveAsTemplate,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: getHeight() * 0.015),

                //  BUTTONS (Fixed at bottom)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonText: al.backButton,
                        onTap: () => Navigator.pop(context),
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.blackColor,
                        textColor: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: getWidth() * 0.04),
                    Expanded(
                      child: CustomButton(
                        buttonText: al.sendNow,
                          onTap: () async {
                            final provider = context.read<TemplateProvider>();

                            double? lat = double.tryParse(widget.producerLat.replaceAll(',', '.'));
                            double? long = double.tryParse(widget.producerLong.replaceAll(',', '.'));
                            if (lat == null || long == null) {
                              Toasts.getErrorToast(text: "Invalid producer location");
                              return;
                            }

                            if (widget.data.offerId != null) {
                              // Editing an existing offer
                              bool success = await provider.editProducerOffer(
                                context: context,
                                offerId: widget.data.offerId!,
                                title: widget.data.title,
                                message: widget.data.message,
                                discountPercent: widget.data.reduction,
                                validityMinutes: widget.data.validityMinutes,
                                maxRecipients: widget.data.maxRecipients,
                                radiusMeters: widget.data.radiusMeters,
                                saveAsTemplate: saveTemplate,
                              );

                              if (success) Navigator.pop(context);
                            } else {
                              // Creating a new offer
                              bool success = await provider.sendProducerOffer(
                                context: context,
                                producerId: widget.producerId,
                                title: widget.data.title,
                                message: widget.data.message,
                                discountPercent: widget.data.reduction,
                                validityMinutes: widget.data.validityMinutes,
                                maxRecipients: widget.data.maxRecipients,
                                radiusMeters: widget.data.radiusMeters,
                                saveAsTemplate: saveTemplate,
                                latitude: lat,
                                longitude: long,
                              );

                              if (success) Navigator.pop(context);
                            }
                          },
                        backgroundColor:
                        AppColors.getPrimaryColorFromContext(context),
                        borderColor:
                        AppColors.getPrimaryColorFromContext(context),
                      ),
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


class IncrementSelector extends StatefulWidget {
  final TextEditingController controller;
  final int step;
  final int min;
  final int max;
  final String unit;

  const IncrementSelector({
    super.key,
    required this.controller,
    required this.step,
    this.min = 0,
    this.max = 9999,
    this.unit = '',
  });

  @override
  State<IncrementSelector> createState() => _IncrementSelectorState();
}

class _IncrementSelectorState extends State<IncrementSelector> {
  int get _currentValue {
    final text = widget.controller.text.replaceAll(widget.unit, '').trim();
    return int.tryParse(text) ?? 0;
  }

  void _updateValue(int newValue) {
    final clamped = newValue.clamp(widget.min, widget.max);
    widget.controller.text =
    widget.unit.isEmpty ? '$clamped' : '$clamped${widget.unit}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = getHeight() * 0.07; // same as CustomField2
    final borderRadius = 15.0; // same as CustomField2

    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.greyBordersColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // --- Decrement Button ---
          InkWell(
            onTap: () => _updateValue(_currentValue - widget.step),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
            ),
            child: Container(
              width: fieldHeight, // square button
              height: fieldHeight,
              alignment: Alignment.center,
              child: const Icon(Icons.remove, size: 20),
            ),
          ),

          // --- Value Display ---
          Expanded(
            child: Center(
              child: Text(
                widget.controller.text.isEmpty
                    ? '0${widget.unit}'
                    : widget.controller.text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizes!.fontSize15,
                  color: HexColor.fromHex("#1E1E2D"),
                  fontFamily: Assets.onsetMedium,
                ),
              ),
            ),
          ),

          // --- Increment Button ---
          InkWell(
            onTap: () => _updateValue(_currentValue + widget.step),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
            child: Container(
              width: fieldHeight, // square button
              height: fieldHeight,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
