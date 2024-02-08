// import 'package:core/context/navigation_extension.dart';
// import 'package:core/helpers/app_size.dart';
// import 'package:core/styles/color_palette.dart';
// import 'package:core/styles/text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:main/widgets/dividers/section_divider.dart';
// import 'package:main/widgets/spacing_column.dart';

// import 'widgets/top_stat_card.dart';

// class StudentFinalGrade extends StatelessWidget {
//   const StudentFinalGrade({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Final Grade"),
//       ).variant(),
//       body: const SingleChildScrollView(
//         child: SpacingColumn(
//           horizontalPadding: 16,
//           spacing: 12,
//           children: [
//             SizedBox(
//               height: 16,
//             ),
//             TopStatCard(
//               title: 'Final Grade Statistic',
//               score: 1100,
//             ),
//             ...[
//               const FinalGradeScoreCard(
//                 type: 'CBT Test',
//                 score: 90,
//                 proportion: 30,
//                 date: 'Sen, 27 Mar 2023',
//               ),
//               const FinalGradeScoreCard(
//                 type: 'OSCE Test',
//                 score: 92,
//                 proportion: 30,
//                 date: 'Sen, 27 Mar 2023',
//               ),
//               const FinalGradeScoreCard(
//                 type: 'Mini Cex',
//                 score: 90,
//                 proportion: 25,
//                 date: 'Sen, 27 Mar 2023',
//               ),
//               const FinalGradeScoreCard(
//                 type: 'Case Report',
//                 score: 90,
//                 proportion: 15,
//                 date: 'Sen, 27 Mar 2023',
//               ),
//               const FinalGradeScoreCard(
//                 type: 'Personal Behavior',
//                 score: 90,
//                 date: 'Sen, 27 Mar 2023',
//               )
//             ],
//             SizedBox(
//               height: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FinalGradeScoreCard extends StatelessWidget {
//   const FinalGradeScoreCard({
//     super.key,
//     required this.type,
//     required this.score,
//     this.proportion,
//     required this.date,
//   });

//   final String type;
//   final int? proportion;
//   final String date;
//   final int score;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: AppSize.getAppWidth(context),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: scaffoldBackgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               offset: const Offset(0, 0),
//               spreadRadius: 0,
//               blurRadius: 6,
//               color: const Color(0xFFD4D4D4).withOpacity(.25)),
//           BoxShadow(
//               offset: const Offset(0, 4),
//               spreadRadius: 0,
//               blurRadius: 24,
//               color: const Color(0xFFD4D4D4).withOpacity(.25)),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       ConstrainedBox(
//                         constraints: const BoxConstraints(
//                           maxWidth: 200,
//                         ),
//                         child: Text(
//                           type,
//                           style: textTheme.titleMedium?.copyWith(
//                             color: secondaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 8,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: proportion != null
//                               ? const Color(0xFF219ABF)
//                               : scaffoldBackgroundColor,
//                           border: proportion != null
//                               ? null
//                               : Border.all(
//                                   width: 1,
//                                   color: secondaryColor,
//                                 ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.all(8),
//                         child: Text(
//                           proportion != null ? '$proportion%' : 'Formatif',
//                           style: textTheme.labelSmall?.copyWith(
//                             color: proportion != null
//                                 ? scaffoldBackgroundColor
//                                 : secondaryColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Text(
//                     'Exam date',
//                     style: textTheme.bodySmall?.copyWith(
//                       color: primaryTextColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     date,
//                     style: textTheme.bodySmall?.copyWith(
//                       color: secondaryTextColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SectionDivider(
//               isVertical: true,
//             ),
//             SizedBox(
//               width: 70,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Score',
//                     style: textTheme.bodyMedium?.copyWith(
//                       color: secondaryTextColor,
//                     ),
//                   ),
//                   Text(
//                     score.toString(),
//                     style: textTheme.headlineSmall?.copyWith(
//                       color: primaryTextColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
