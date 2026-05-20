
// // lib/app/modules/general_user_flow/trip_details_screen/widget/priority_reminder_bottom_sheets.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:hamishphipps/app/core/constants/app_button.dart';
// import 'package:hamishphipps/app/core/constants/app_colors.dart';
// import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/controller/trip_details_controller.dart';
// import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';

// // ─── Passport Bottom Sheet ───────────────────────────────────────────────────

// class PassportBottomSheet extends StatefulWidget {
//   final PriorityRemainder reminder;
//   final String state;
//   final TripDetailsController controller;

//   const PassportBottomSheet({
//     super.key,
//     required this.reminder,
//     required this.state,
//     required this.controller,
//   });

//   @override
//   State<PassportBottomSheet> createState() => _PassportBottomSheetState();
// }

// class _PassportBottomSheetState extends State<PassportBottomSheet> {
//   late final TextEditingController countryController;
//   late final TextEditingController expiryController;

//   @override
//   void initState() {
//     super.initState();
//     countryController = TextEditingController(
//       text: widget.reminder.passportCountry ?? '',
//     );
//     expiryController = TextEditingController(
//       text: widget.reminder.passportExpiry != null &&
//               widget.reminder.passportExpiry!.year > 1900
//           ? widget.reminder.passportExpiry!.toIso8601String().split('T')[0]
//           : '',
//     );
//   }

//   @override
//   void dispose() {
//     countryController.dispose();
//     expiryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildHeader(),
//             const Divider(),
//             _buildBody(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFffe7d9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.document_scanner,
//                     color: AppColors.authOrange, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Passport',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                   Text(
//                     widget.state == 'add'
//                         ? 'Add your passport details'
//                         : widget.state == 'update'
//                             ? 'Update passport details'
//                             : 'Passport verified',
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           GestureDetector(
//               onTap: () => Get.back(),
//               child: const Icon(Icons.close, size: 24)),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Issuing Country',
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: countryController,
//             decoration: _inputDecoration('e.g. Bangladesh'),
//           ),
//           const SizedBox(height: 20),
//           const Text('Passport Expiry Date',
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: expiryController,
//             readOnly: true,
//             onTap: () async {
//               final selectedDate = await showDatePicker(
//                 context: context,
//                 initialDate: widget.reminder.passportExpiry != null &&
//                         widget.reminder.passportExpiry!.year > 1900
//                     ? widget.reminder.passportExpiry!
//                     : DateTime.now().add(const Duration(days: 1)),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(const Duration(days: 3650)),
//               );
//               if (selectedDate != null) {
//                 // setState দিয়ে controller update করো
//                 setState(() {
//                   expiryController.text =
//                       selectedDate.toIso8601String().split('T')[0];
//                 });
//               }
//             },
//             decoration: _inputDecoration('Select expiry date',
//                 suffix: const Icon(Icons.calendar_today)),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: appButton(
//                   borderColor: AppColors.authOrange,
//                   bgColor: Colors.transparent,
//                   onTap: () => Get.back(),
//                   name: "Cancel",
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 // ✅ Obx শুধু loading indicator এর জন্য — outer build এ কোনো conflict নেই
//                 child: Obx(() => appButton(
//                       textColor: Colors.white,
//                       onTap: () {
//                         if (widget.controller.isPriorityLoading.value) return;
//                         if (countryController.text.isEmpty ||
//                             expiryController.text.isEmpty) {
//                           AppSnackbar.failed('Please fill all fields');
//                           return;
//                         }
//                         widget.controller.changePriority(
//                           widget.reminder.id ?? '',
//                           passportCountry: countryController.text,
//                           passportExpiry: expiryController.text,
//                         );
//                         Future.delayed(const Duration(milliseconds: 500),
//                             () => Get.back());
//                       },
//                       name: widget.controller.isPriorityLoading.value
//                           ? "Saving..."
//                           : "Save",
//                     )),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none),
//       suffixIcon: suffix,
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     );
//   }
// }

// // ─── Visa Bottom Sheet ────────────────────────────────────────────────────────

// class VisaBottomSheet extends StatefulWidget {
//   final PriorityRemainder reminder;
//   final TripDetailsController controller;

//   const VisaBottomSheet({
//     super.key,
//     required this.reminder,
//     required this.controller,
//   });

//   @override
//   State<VisaBottomSheet> createState() => _VisaBottomSheetState();
// }

// class _VisaBottomSheetState extends State<VisaBottomSheet> {
//   late bool isVisaConfirmed;
//   late bool noVisaRequired;
//   late bool needsAttention;
//   late final TextEditingController notesController;

//   @override
//   void initState() {
//     super.initState();
//     isVisaConfirmed = widget.reminder.isVisaConfirmed ?? false;
//     noVisaRequired = widget.reminder.noVisaRequired ?? false;
//     needsAttention = widget.reminder.needsAttention ?? false;
//     notesController =
//         TextEditingController(text: widget.reminder.visaNotes ?? '');
//   }

//   @override
//   void dispose() {
//     notesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFffe7d9),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(Icons.badge,
//                             color: AppColors.authOrange, size: 24),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text('Visa',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                   GestureDetector(
//                       onTap: () => Get.back(),
//                       child: const Icon(Icons.close, size: 24)),
//                 ],
//               ),
//             ),
//             const Divider(),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Have you checked visa requirements?',
//                       style: TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 16),

//                   // ✅ setState ব্যবহার করো — Obx এর কোনো দরকার নেই
//                   // VisaBottomSheet এর State class এ এই 3টা onTap replace করো

//                 _ToggleOption(
//                   title: 'Visa Confirmed / Obtained',
//                   subtitle: 'I have the necessary visa(s) or have confirmed I don\'t need one',
//                   isSelected: isVisaConfirmed,
//                   onTap: () => setState(() {
//                     isVisaConfirmed = true;
//                     noVisaRequired = false;
//                     needsAttention = false;
//                   }),
//                 ),
//                 const SizedBox(height: 12),
//                 _ToggleOption(
//                   title: 'No Visa Required',
//                   subtitle: 'My passport allows visa-free entry to all destinations',
//                   isSelected: noVisaRequired,
//                   onTap: () => setState(() {
//                     isVisaConfirmed = false;
//                     noVisaRequired = true;
//                     needsAttention = false;
//                   }),
//                 ),
//                 const SizedBox(height: 12),
//                 _ToggleOption(
//                   title: 'Needs Attention',
//                   subtitle: 'I still need to apply for or check visa requirements',
//                   isSelected: needsAttention,
//                   onTap: () => setState(() {
//                     isVisaConfirmed = false;
//                     noVisaRequired = false;
//                     needsAttention = true;
//                   }),
//                 ),
//                   const SizedBox(height: 20),

//                   // ✅ AI Visa Summary — Obx আলাদা widget এ isolate করা হয়েছে
//                   _VisaAiSummaryCard(controller: widget.controller),

//                   const SizedBox(height: 16),
//                   const Text('Notes',
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey)),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: notesController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: 'describe',
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: appButton(
//                           borderColor: AppColors.authOrange,
//                           bgColor: Colors.transparent,
//                           onTap: () => Get.back(),
//                           name: "Cancel",
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Obx(() => appButton(
//                               textColor: Colors.white,
//                               onTap: () {
//                                 if (widget.controller.isPriorityLoading.value)
//                                   return;
//                                 widget.controller.changePriority(
//                                   widget.reminder.id ?? '',
//                                   isVisaConfirmed: isVisaConfirmed,
//                                   noVisaRequired: noVisaRequired,
//                                   needsAttention: needsAttention,
//                                   visaNotes: notesController.text,
//                                 );
//                                 Future.delayed(
//                                     const Duration(milliseconds: 500),
//                                     () => Get.back());
//                               },
//                               name: widget.controller.isPriorityLoading.value
//                                   ? "Saving..."
//                                   : "Mark as Reviewed",
//                             )),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ✅ AI Summary card আলাদা widget — Obx এখন isolated
// class _VisaAiSummaryCard extends StatelessWidget {
//   final TripDetailsController controller;
//   const _VisaAiSummaryCard({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(5),
//       width: double.infinity,
//       constraints: const BoxConstraints(minHeight: 80),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(20),
//         border: const GradientBoxBorder(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFF7E40), Color(0xFFFF3366), Color(0xFF3388FF)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Trav AI - Visa Summary",
//               style:
//                   TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Obx(() {
//             if (controller.isVisaSummeryLoading.value) {
//               return const Center(
//                   child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(),
//               ));
//             }
//             final destinations =
//                 controller.visaAiSummerData.value.destinations ?? [];
//             if (destinations.isEmpty) {
//               return const Text("No visa info available.",
//                   style: TextStyle(color: Colors.grey, fontSize: 12));
//             }
//             return ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: destinations.length,
//               itemBuilder: (context, index) {
//                 final data = destinations[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: Text(
//                       "• ${data.city} ${data.country} — ${data.visaType} (${data.processingTime})"),
//                 );
//               },
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// // ─── Travel Insurance Bottom Sheet ───────────────────────────────────────────

// class TravelInsuranceBottomSheet extends StatefulWidget {
//   final PriorityRemainder reminder;
//   final TripDetailsController controller;

//   const TravelInsuranceBottomSheet({
//     super.key,
//     required this.reminder,
//     required this.controller,
//   });

//   @override
//   State<TravelInsuranceBottomSheet> createState() =>
//       _TravelInsuranceBottomSheetState();
// }

// class _TravelInsuranceBottomSheetState
//     extends State<TravelInsuranceBottomSheet> {
//   late bool hasInsurance;

//   @override
//   void initState() {
//     super.initState();
//     hasInsurance = widget.reminder.haveInsurance ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFffe7d9),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(Icons.shield,
//                             color: AppColors.authOrange, size: 24),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text('Travel Insurance',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                   GestureDetector(
//                       onTap: () => Get.back(),
//                       child: const Icon(Icons.close, size: 24)),
//                 ],
//               ),
//             ),
//             const Divider(),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Do you have travel insurance?',
//                       style: TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 16),
//                   _ToggleOption(
//                     title: 'Yes, I have insurance',
//                     subtitle: 'I have travel insurance coverage for this trip',
//                     isSelected: hasInsurance,
//                     onTap: () => setState(() => hasInsurance = true),
//                   ),
//                   const SizedBox(height: 12),
//                   _ToggleOption(
//                     title: 'Not yet / Need to get',
//                     subtitle: 'I still need to purchase travel insurance',
//                     isSelected: !hasInsurance,
//                     onTap: () => setState(() => hasInsurance = false),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: appButton(
//                           borderColor: AppColors.authOrange,
//                           bgColor: Colors.transparent,
//                           onTap: () => Get.back(),
//                           name: "Cancel",
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Obx(() => appButton(
//                               textColor: Colors.white,
//                               onTap: () {
//                                 if (widget.controller.isPriorityLoading.value)
//                                   return;
//                                 widget.controller.changePriority(
//                                   widget.reminder.id ?? '',
//                                   haveInsurance: hasInsurance,
//                                 );
//                                 Future.delayed(
//                                     const Duration(milliseconds: 500),
//                                     () => Get.back());
//                               },
//                               name: widget.controller.isPriorityLoading.value
//                                   ? "Saving..."
//                                   : "Save",
//                             )),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Reusable Toggle Option ───────────────────────────────────────────────────

// class _ToggleOption extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _ToggleOption({
//     required this.title,
//     required this.subtitle,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.authOrange : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 4),
//                   Text(subtitle,
//                       style:
//                           const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? AppColors.authOrange : Colors.grey,
//                   width: 2,
//                 ),
//                 color:
//                     isSelected ? AppColors.authOrange : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, size: 16, color: Colors.white)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/controller/trip_details_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/trip_details_screen/model/trip_details_model.dart';

// ─── Abstract Interface ───────────────────────────────────────────────────────

abstract class PriorityReminderHandler {
  RxBool get isPriorityLoading;
  Future<void> changePriority(
    String reminderId, {
    String? passportCountry,
    String? passportExpiry,
    bool? isVisaConfirmed,
    bool? noVisaRequired,
    bool? needsAttention,
    String? visaNotes,
    bool? haveInsurance,
  });
}

// ─── Passport Bottom Sheet ────────────────────────────────────────────────────

class PassportBottomSheet extends StatefulWidget {
  final PriorityRemainder reminder;
  final String state;
  final PriorityReminderHandler controller;

  const PassportBottomSheet({
    super.key,
    required this.reminder,
    required this.state,
    required this.controller,
  });

  @override
  State<PassportBottomSheet> createState() => _PassportBottomSheetState();
}

class _PassportBottomSheetState extends State<PassportBottomSheet> {
  late final TextEditingController countryController;
  late final TextEditingController expiryController;

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController(
      text: widget.reminder.passportCountry ?? '',
    );
    expiryController = TextEditingController(
      text: widget.reminder.passportExpiry != null &&
              widget.reminder.passportExpiry!.year > 1900
          ? widget.reminder.passportExpiry!.toIso8601String().split('T')[0]
          : '',
    );
  }

  @override
  void dispose() {
    countryController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFffe7d9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.document_scanner,
                  color: AppColors.authOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Passport',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    widget.state == 'add'
                        ? 'Add your passport details'
                        : widget.state == 'update'
                            ? 'Update passport details'
                            : 'Passport verified',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Issuing Country',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: countryController,
            decoration: _inputDecoration('e.g. Bangladesh'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Passport Expiry Date',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: expiryController,
            readOnly: true,
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: widget.reminder.passportExpiry != null &&
                        widget.reminder.passportExpiry!.year > 1900
                    ? widget.reminder.passportExpiry!
                    : DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (selectedDate != null) {
                setState(() {
                  expiryController.text =
                      selectedDate.toIso8601String().split('T')[0];
                });
              }
            },
            decoration: _inputDecoration(
              'Select expiry date',
              suffix: const Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: appButton(
                  borderColor: AppColors.authOrange,
                  bgColor: Colors.transparent,
                  onTap: () => Get.back(),
                  name: "Cancel",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => appButton(
                    textColor: Colors.white,
                    onTap: () {
                      if (widget.controller.isPriorityLoading.value) return;
                      if (countryController.text.isEmpty ||
                          expiryController.text.isEmpty) {
                        AppSnackbar.failed('Please fill all fields');
                        return;
                      }
                      widget.controller.changePriority(
                        widget.reminder.id ?? '',
                        passportCountry: countryController.text,
                        passportExpiry: expiryController.text,
                      );
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () => Get.back(),
                      );
                    },
                    name: widget.controller.isPriorityLoading.value
                        ? "Saving..."
                        : "Save",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

// ─── Visa Bottom Sheet ────────────────────────────────────────────────────────

class VisaBottomSheet extends StatefulWidget {
  final PriorityRemainder reminder;
  final PriorityReminderHandler controller;
  final bool showAiCard;

  const VisaBottomSheet({
    super.key,
    required this.reminder,
    required this.controller,
    this.showAiCard = true,
  });

  @override
  State<VisaBottomSheet> createState() => _VisaBottomSheetState();
}

class _VisaBottomSheetState extends State<VisaBottomSheet> {
  late String selectedOption;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    if (widget.reminder.isVisaConfirmed == true) {
      selectedOption = 'confirmed';
    } else if (widget.reminder.noVisaRequired == true) {
      selectedOption = 'no_visa';
    } else if (widget.reminder.needsAttention == true) {
      selectedOption = 'attention';
    } else {
      selectedOption = '';
    }
    notesController =
        TextEditingController(text: widget.reminder.visaNotes ?? '');
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFffe7d9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.badge,
                          color: AppColors.authOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Visa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Have you checked visa requirements?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ToggleOption(
                    title: 'Visa Confirmed / Obtained',
                    subtitle:
                        "I have the necessary visa(s) or have confirmed I don't need one",
                    isSelected: selectedOption == 'confirmed',
                    onTap: () => setState(() => selectedOption = 'confirmed'),
                  ),
                  const SizedBox(height: 12),
                  _ToggleOption(
                    title: 'No Visa Required',
                    subtitle:
                        'My passport allows visa-free entry to all destinations',
                    isSelected: selectedOption == 'no_visa',
                    onTap: () => setState(() => selectedOption = 'no_visa'),
                  ),
                  const SizedBox(height: 12),
                  _ToggleOption(
                    title: 'Needs Attention',
                    subtitle:
                        'I still need to apply for or check visa requirements',
                    isSelected: selectedOption == 'attention',
                    onTap: () => setState(() => selectedOption = 'attention'),
                  ),
                  const SizedBox(height: 20),

                  // ✅ showAiCard true হলেই দেখাবে (TripDetails only)
                  if (widget.showAiCard) ...[
                    _VisaAiSummaryCard(
                      controller:
                          widget.controller as TripDetailsController,
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'describe',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: appButton(
                          borderColor: AppColors.authOrange,
                          bgColor: Colors.transparent,
                          onTap: () => Get.back(),
                          name: "Cancel",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => appButton(
                            textColor: Colors.white,
                            onTap: () {
                              if (widget.controller.isPriorityLoading.value)
                                return;
                              widget.controller.changePriority(
                                widget.reminder.id ?? '',
                                isVisaConfirmed: selectedOption == 'confirmed',
                                noVisaRequired: selectedOption == 'no_visa',
                                needsAttention: selectedOption == 'attention',
                                visaNotes: notesController.text,
                              );
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () => Get.back(),
                              );
                            },
                            name: widget.controller.isPriorityLoading.value
                                ? "Saving..."
                                : "Mark as Reviewed",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Visa AI Summary Card (TripDetails only) ──────────────────────────────────

class _VisaAiSummaryCard extends StatelessWidget {
  final TripDetailsController controller;

  const _VisaAiSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF7E40),
              Color(0xFFFF3366),
              Color(0xFF3388FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Trav AI - Visa Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isVisaSummeryLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final destinations =
                controller.visaAiSummerData.value.destinations ?? [];
            if (destinations.isEmpty) {
              return const Text(
                "No visa info available.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final data = destinations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    "• ${data.city} ${data.country} — ${data.visaType} (${data.processingTime})",
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

// ─── Travel Insurance Bottom Sheet ───────────────────────────────────────────

class TravelInsuranceBottomSheet extends StatefulWidget {
  final PriorityRemainder reminder;
  final PriorityReminderHandler controller;

  const TravelInsuranceBottomSheet({
    super.key,
    required this.reminder,
    required this.controller,
  });

  @override
  State<TravelInsuranceBottomSheet> createState() =>
      _TravelInsuranceBottomSheetState();
}

class _TravelInsuranceBottomSheetState
    extends State<TravelInsuranceBottomSheet> {
  late bool hasInsurance;

  @override
  void initState() {
    super.initState();
    hasInsurance = widget.reminder.haveInsurance ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFffe7d9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: AppColors.authOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Travel Insurance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Do you have travel insurance?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ToggleOption(
                    title: 'Yes, I have insurance',
                    subtitle: 'I have travel insurance coverage for this trip',
                    isSelected: hasInsurance,
                    onTap: () => setState(() => hasInsurance = true),
                  ),
                  const SizedBox(height: 12),
                  _ToggleOption(
                    title: 'Not yet / Need to get',
                    subtitle: 'I still need to purchase travel insurance',
                    isSelected: !hasInsurance,
                    onTap: () => setState(() => hasInsurance = false),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: appButton(
                          borderColor: AppColors.authOrange,
                          bgColor: Colors.transparent,
                          onTap: () => Get.back(),
                          name: "Cancel",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => appButton(
                            textColor: Colors.white,
                            onTap: () {
                              if (widget.controller.isPriorityLoading.value)
                                return;
                              widget.controller.changePriority(
                                widget.reminder.id ?? '',
                                haveInsurance: hasInsurance,
                              );
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () => Get.back(),
                              );
                            },
                            name: widget.controller.isPriorityLoading.value
                                ? "Saving..."
                                : "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Toggle Option ───────────────────────────────────────────────────

class _ToggleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.authOrange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.authOrange : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? AppColors.authOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}