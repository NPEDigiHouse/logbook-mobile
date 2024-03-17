// import 'package:core/context/navigation_extension.dart';
// import 'package:core/helpers/utils.dart';
// import 'package:core/styles/color_palette.dart';
// import 'package:core/styles/text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
// import 'package:main/widgets/inputs/input_date_field.dart';
// import 'package:main/widgets/verify_dialog.dart';

// class AddWeekDialog extends StatefulWidget {
//   final String departmentId;
//   final int weekNum;
//   final DateTime? endDate;
//   final String? id;
//   const AddWeekDialog({
//     super.key,
//     this.id,
//     this.endDate,
//     required this.departmentId,
//     required this.weekNum,
//   });

//   @override
//   State<AddWeekDialog> createState() => _AddWeekDialogState();
// }

// class _AddWeekDialogState extends State<AddWeekDialog> {
//   final TextEditingController startDateController = TextEditingController();
//   final TextEditingController endDateController = TextEditingController();
//   bool status = false;
//   bool isExpiredDate = false;
//   bool isExpired = false;
//   final _formKey = GlobalKey<FormBuilderState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DailyActivityCubit, DailyActivityState>(
//       listener: (context, state) {
//         if (state.isAddWeekSuccess) {
//           BlocProvider.of<DailyActivityCubit>(context)
//               .getStudentDailyActivities();
//           Navigator.pop(context);
//         }
//       },
//       child: Dialog(
//         elevation: 0,
//         insetPadding: const EdgeInsets.symmetric(
//           vertical: 24,
//           horizontal: 36,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: FormBuilder(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Stack(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8, left: 4),
//                       child: IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(
//                           Icons.close_rounded,
//                           color: onFormDisableColor,
//                         ),
//                         tooltip: 'Close',
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Center(
//                         child: Text(
//                           'Add New Week',
//                           style: textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//                   child: Text(
//                     'Week ${widget.weekNum}',
//                     style: textTheme.titleLarge,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: InputDateField(
//                     action: (d) {},
//                     controller: startDateController,
//                     hintText: 'Start Date',
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'This field is required';
//                       }
//                       final sd =
//                           Utils.stringToDateTime(startDateController.text);
//                       if (sd.weekday != DateTime.monday) {
//                         return 'The startDate must be a Monday';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
//                   child: InputDateField(
//                     action: (d) {
//                       if (d.isBefore(DateTime.now())) {
//                         status = false;
//                         isExpiredDate = true;
//                         isExpired = true;
//                         setState(() {});
//                       } else {
//                         status = true;
//                         isExpiredDate = false;
//                         isExpired = false;
//                         setState(() {});
//                       }
//                     },
//                     controller: endDateController,
//                     hintText: 'End Date',
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'This field is required';
//                       }
//                       final sd =
//                           Utils.stringToDateTime(startDateController.text);
//                       final ed = Utils.stringToDateTime(endDateController.text);
//                       final difference = ed.difference(sd).inDays;
//                       if (difference > 7) {
//                         return 'Max ranges in a weeks is 7 days';
//                       }
//                       if (!ed.isAfter(sd)) {
//                         return 'End Date must be after start date';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                   child: FilledButton(
//                     onPressed: () {
//                       FocusScope.of(context).unfocus();
//                       if (_formKey.currentState!.saveAndValidate()) {
//                         showDialog(
//                           context: context,
//                           barrierLabel: '',
//                           barrierDismissible: false,
//                           builder: (_) => VerifyDialog(
//                             onTap: () {
//                               final start = Utils.stringToDateTime(
//                                   startDateController.text);
//                               final end = Utils.stringToDateTime(
//                                   endDateController.text);
//                               BlocProvider.of<DailyActivityCubit>(context)
//                                   .addWeekByStudent(
//                                 startDate: DateTime(start.year, start.month,
//                                             start.day, 13, 0, 0)
//                                         .millisecondsSinceEpoch ~/
//                                     1000,
//                                 endDate: DateTime(end.year, end.month, end.day,
//                                             13, 0, 0)
//                                         .millisecondsSinceEpoch ~/
//                                     1000,
//                                 weekNum: widget.weekNum,
//                               );
//                               Navigator.pop(context);
//                             },
//                             isSubmit: true,
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text('Submit'),
//                   ).fullWidth(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
