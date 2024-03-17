// import 'package:core/context/navigation_extension.dart';
// import 'package:core/helpers/utils.dart';
// import 'package:core/styles/color_palette.dart';
// import 'package:core/styles/text_style.dart';
// import 'package:data/models/daily_activity/list_week_item.dart';
// import 'package:data/models/units/unit_model.dart';
// import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
// import 'package:main/widgets/custom_loading.dart';
// import 'package:main/widgets/dividers/item_divider.dart';
// import 'package:main/widgets/empty_data.dart';
// import 'package:main/widgets/headers/unit_header.dart';
// import 'package:main/widgets/verify_dialog.dart';

// import 'add_week_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class DailyActivityAddWeekPage extends StatefulWidget {
//   final DepartmentModel unit;
//   const DailyActivityAddWeekPage({super.key, required this.unit});

//   @override
//   State<DailyActivityAddWeekPage> createState() =>
//       _DailyActivityAddWeekPageState();
// }

// class _DailyActivityAddWeekPageState extends State<DailyActivityAddWeekPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
//       ..getListWeek(unitId: widget.unit.id));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Week of Deparment'),
//       ).variant(),
//       body: RefreshIndicator(
//         onRefresh: () => Future.wait([
//           Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
//             ..getListWeek(unitId: widget.unit.id)),
//         ]),
//         child: SafeArea(
//           child: CustomScrollView(
//             slivers: [
//               const SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 16,
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 sliver: SliverToBoxAdapter(
//                   child: DepartmentHeader(unitName: widget.unit.name),
//                 ),
//               ),
//               const SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 16,
//                 ),
//               ),
//               // BlocBuilder<DailyActivityCubit, DailyActivityState>(
//               //   builder: (context, state) {
//               //     if (state.weekItems != null) {
//               //       return SliverPadding(
//               //         padding: const EdgeInsets.symmetric(horizontal: 16),
//               //         sliver: SliverToBoxAdapter(
//               //           child: AddWeeksCard(
//               //             unitId: widget.unit.id,
//               //             index: state.weekItems!.length,
//               //           ),
//               //         ),
//               //       );
//               //     }
//               //     return const SliverToBoxAdapter(child: SizedBox.shrink());
//               //   },
//               // ),
//               const SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 16,
//                 ),
//               ),
//               BlocConsumer<DailyActivityCubit, DailyActivityState>(
//                 listener: (context, state) {
//                   if (state.isRemoveWeekSuccess) {
//                     BlocProvider.of<DailyActivityCubit>(context)
//                         .getListWeek(unitId: widget.unit.id);
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state.weekItems != null) {
//                     if (state.weekItems!.isNotEmpty) {
//                       return SliverPadding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         sliver: SliverList.separated(
//                           itemCount: state.weekItems!.length,
//                           itemBuilder: (context, index) {
//                             final data = state.weekItems![index].days ?? [];

//                             data.sort(
//                               (a, b) {
//                                 // Urutkan berdasarkan urutan hari dalam seminggu
//                                 final daysOfWeek = [
//                                   'MONDAY',
//                                   'TUESDAY',
//                                   'WEDNESDAY',
//                                   'THURSDAY',
//                                   'FRIDAY',
//                                   'SATURDAY',
//                                   'SUNDAY'
//                                 ];
//                                 return daysOfWeek
//                                     .indexOf(a.day!)
//                                     .compareTo(daysOfWeek.indexOf(b.day!));
//                               },
//                             );
//                             return DailyActivtyWeekCard(
//                               days: data,
//                               departmentId: widget.unit.id,
//                               weekItem: state.weekItems![index],
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return const SizedBox(
//                               height: 12,
//                             );
//                           },
//                         ),
//                       );
//                     } else {
//                       return const SliverToBoxAdapter(
//                         child: EmptyData(
//                             title: 'No Weeks Added',
//                             subtitle: 'Please add week before'),
//                       );
//                     }
//                   }

//                   return const SliverToBoxAdapter(child: CustomLoading());
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DailyActivtyWeekCard extends StatefulWidget {
//   const DailyActivtyWeekCard({
//     super.key,
//     required this.days,
//     required this.weekItem,
//     required this.departmentId,
//   });

//   final List<Day> days;
//   final String departmentId;
//   final ListWeekItem weekItem;

//   @override
//   State<DailyActivtyWeekCard> createState() => _DailyActivtyWeekCardState();
// }

// class _DailyActivtyWeekCardState extends State<DailyActivtyWeekCard> {
//   @override
//   Widget build(BuildContext context) {
//     final startDate = DateTime.fromMillisecondsSinceEpoch(
//         widget.weekItem.startDate == null
//             ? DateTime.now().millisecondsSinceEpoch
//             : widget.weekItem.startDate! * 1000);
//     final endDate = DateTime.fromMillisecondsSinceEpoch(
//         widget.weekItem.endDate == null
//             ? DateTime.now().millisecondsSinceEpoch
//             : widget.weekItem.endDate! * 1000);
//     bool expiredDate = endDate.isBefore(DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//     ));
//     bool expired = expiredDate && widget.weekItem.status == false;
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 12,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Builder(builder: (context) {
//                       return Text(
//                         Utils.epochToStringDate(
//                             startTime: widget.weekItem.startDate ??
//                                 DateTime.now().millisecondsSinceEpoch ~/ 1000,
//                             endTime: widget.weekItem.endDate ??
//                                 DateTime.now().millisecondsSinceEpoch ~/ 1000),
//                         style: textTheme.bodyMedium?.copyWith(
//                           color: secondaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       );
//                     }),
//                     Text(
//                       'Status: ${expired ? "Expired" : "Active"}',
//                       style: textTheme.bodySmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               PopupMenuButton<String>(
//                 icon: const Icon(
//                   Icons.more_vert_rounded,
//                 ),
//                 onSelected: (value) {
//                   if (value == 'Edit') {
//                     showDialog(
//                       context: context,
//                       barrierLabel: '',
//                       barrierDismissible: false,
//                       builder: (_) => AddWeekDialog(
                        
//                         weekNum: widget.weekItem.weekName ?? 0,
                       
//                         id: widget.weekItem.id,
//                       ),
//                     );
//                   }

//                   if (value == 'Delete') {
//                     showDialog(
//                       context: context,
//                       barrierLabel: '',
//                       barrierDismissible: false,
//                       builder: (_) => VerifyDialog(
//                         onTap: () {
//                           BlocProvider.of<DailyActivityCubit>(context)
//                               .deleteWeekByCoordinator(id: widget.weekItem.id!);
//                           Navigator.pop(context);
//                         },
//                       ),
//                     );
//                   }
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return <PopupMenuEntry<String>>[
//                     const PopupMenuItem<String>(
//                       value: 'Edit',
//                       child: Text('Edit'),
//                     ),
//                     const PopupMenuItem<String>(
//                       value: 'Delete',
//                       child: Text('Delete'),
//                     ),
//                   ];
//                 },
//               ),
            
//             ],
//           ),
//           const SizedBox(
//             height: 6,
//           ),
//           const SizedBox(
//             height: 6,
//           ),
//           const ItemDivider(),
//           const SizedBox(
//             height: 6,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               for (int i = 0; i < widget.days.length; i++)
//                 Text(
//                   widget.days[i].day!.substring(0, 3),
//                   style: textTheme.bodySmall?.copyWith(
//                     color: onFormDisableColor,
//                   ),
//                 )
//             ],
//           ),
//           const SizedBox(
//             height: 6,
//           ),
//           const ItemDivider(),
//         ],
//       ),
//     );
//   }
// }
