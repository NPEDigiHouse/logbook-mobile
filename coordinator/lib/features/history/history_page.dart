// import 'package:common/features/history/history_data.dart';
// import 'package:core/helpers/asset_path.dart';
// import 'package:core/styles/color_palette.dart';
// import 'package:core/styles/text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:grouped_list/sliver_grouped_list.dart';
// import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
// import 'package:main/blocs/history_cubit/history_cubit.dart';
// import 'package:main/widgets/custom_loading.dart';
// import 'package:main/widgets/empty_data.dart';
// import 'package:main/widgets/inputs/search_field.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class CoordinatorHistoryPage extends StatefulWidget {
//   const CoordinatorHistoryPage({
//     super.key,
//   });

//   @override
//   State<CoordinatorHistoryPage> createState() => _CoordinatorHistoryPageState();
// }

// class _CoordinatorHistoryPageState extends State<CoordinatorHistoryPage> {
//   ValueNotifier<List<Activity>> listData = ValueNotifier([]);
//   bool isMounted = false;
//   late final ValueNotifier<String> _query;

//   @override
//   void initState() {
//     Future.microtask(() {
//       BlocProvider.of<HistoryCubit>(context).getHistories();
//     });
//     _query = ValueNotifier('');
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _query.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NestedScrollView(
//       floatHeaderSlivers: true,
//       headerSliverBuilder: (context, innerBoxIsScrolled) {
//         return <Widget>[
//           SliverAppBar(
//             floating: true,
//             automaticallyImplyLeading: false,
//             toolbarHeight: kToolbarHeight + 60,
//             backgroundColor: Colors.transparent,
//             surfaceTintColor: Colors.transparent,
//             systemOverlayStyle: const SystemUiOverlayStyle(
//               statusBarIconBrightness: Brightness.dark,
//             ),
//             flexibleSpace: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 buildTitleSection(),
//                 buildSearchFilterSection(),
//               ],
//             ),
//           ),
//         ];
//       },
//       body: RefreshIndicator(
//         onRefresh: () => Future.wait([
//           BlocProvider.of<HistoryCubit>(context).getHistories(),
//         ]),
//         child: ValueListenableBuilder(
//             valueListenable: listData,
//             builder: (context, s, _) {
//               return BlocConsumer<HistoryCubit, HistoryState>(
//                 listener: (context, state) {
//                   if (state.histories != null &&
//                       state.requestState == RequestState.data) {
//                     if (!isMounted) {
//                       Future.microtask(() {
//                         listData.value = [
//                           ...HistoryHelper.convertHistoryToActivity(
//                               state.histories!, RoleHistory.supervisor, context,
//                               isCoordinator: true)
//                         ];
//                       });
//                       isMounted = true;
//                     }
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state.histories != null &&
//                       state.requestState == RequestState.data) {
//                     if (s.isNotEmpty) {
//                       return CustomScrollView(
//                         slivers: <Widget>[
//                           SliverGroupedListView<Activity, DateTime>(
//                             elements: s,
//                             groupBy: (activity) => activity.date!,
//                             groupComparator: (date1, date2) =>
//                                 date1.compareTo(date2) * -1,
//                             itemBuilder: (context, activity) {
//                               return Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   onTap: activity.onTap,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12,
//                                       horizontal: 20,
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: Container(
//                                             width: 68,
//                                             height: 68,
//                                             color: primaryColor.withOpacity(.1),
//                                             child: Center(
//                                               child: SvgPicture.asset(
//                                                 activity.iconPath,
//                                                 color: primaryColor,
//                                                 width: 32,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               Row(
//                                                 children: <Widget>[
//                                                   Text(
//                                                     activity.title,
//                                                     maxLines: 1,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: textTheme.titleSmall
//                                                         ?.copyWith(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   const Icon(
//                                                     Icons.verified_rounded,
//                                                     size: 16,
//                                                     color: primaryColor,
//                                                   ),
//                                                 ],
//                                               ),
//                                               ...[
//                                                 const SizedBox(height: 12),
//                                                 RichText(
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   text: TextSpan(
//                                                     style: textTheme.bodySmall
//                                                         ?.copyWith(
//                                                       color: secondaryTextColor,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       const TextSpan(
//                                                         text: 'Supervisor:\t',
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                       TextSpan(
//                                                           text: activity
//                                                                   .supervisorId ??
//                                                               '-'),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                               const SizedBox(height: 12),
//                                               RichText(
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 text: TextSpan(
//                                                   style: textTheme.bodySmall
//                                                       ?.copyWith(
//                                                     color: secondaryTextColor,
//                                                   ),
//                                                   children: <TextSpan>[
//                                                     const TextSpan(
//                                                       text: 'Student Name:\t',
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                       ),
//                                                     ),
//                                                     TextSpan(
//                                                         text: activity
//                                                             .studentName),
//                                                   ],
//                                                 ),
//                                               ),
//                                               ...[
//                                                 const SizedBox(height: 4),
//                                                 RichText(
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   text: TextSpan(
//                                                     style: textTheme.bodySmall
//                                                         ?.copyWith(
//                                                       color: secondaryTextColor,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       const TextSpan(
//                                                         text: 'Student Id: ',
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                       TextSpan(
//                                                         text:
//                                                             activity.studentId,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                               if (activity.patientName !=
//                                                   null) ...[
//                                                 const SizedBox(height: 4),
//                                                 RichText(
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   text: TextSpan(
//                                                     style: textTheme.bodySmall
//                                                         ?.copyWith(
//                                                       color: secondaryTextColor,
//                                                     ),
//                                                     children: <TextSpan>[
//                                                       const TextSpan(
//                                                         text: 'Patient: ',
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                       TextSpan(
//                                                         text: activity
//                                                             .patientName,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                               const SizedBox(height: 8),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             groupSeparatorBuilder: (date) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   const Divider(
//                                     height: 6,
//                                     thickness: 6,
//                                     color: onDisableColor,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                         20, 16, 20, 8),
//                                     child: Text(
//                                       timeago.format(date),
//                                       style: textTheme.titleMedium?.copyWith(
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                             separator: const Divider(
//                               height: 1,
//                               thickness: 1,
//                               indent: 20,
//                               endIndent: 20,
//                               color: Color(0xFFEFF0F9),
//                             ),
//                           ),
//                         ],
//                       );
//                     } else {
//                       return const EmptyData(
//                           title: 'No Activity Yet',
//                           subtitle: 'there is no activity history yet');
//                     }
//                   }
//                   return const CustomLoading();
//                 },
//               );
//             }),
//       ),
//     );
//   }

//   Stack buildTitleSection() {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           right: 16,
//           top: 0,
//           child: SvgPicture.asset(
//             AssetPath.getVector('circle_bg2.svg'),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 32, 8, 0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 'History',
//                 style: textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: primaryColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   dynamic buildSearchFilterSection() {
//     return BlocBuilder<HistoryCubit, HistoryState>(
//       builder: (context, state) {
//         return Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8,
//                 horizontal: 20,
//               ),
//               child: SearchField(
//                 text: '',
//                 hint: 'Search Student',
//                 onClear: () {
//                   listData.value.clear();
//                   listData.value = [
//                     ...HistoryHelper.convertHistoryToActivity(
//                         state.histories!, RoleHistory.supervisor, context,
//                         isCoordinator: true)
//                   ];
//                 },
//                 onChanged: (value) {
//                   final data = state.histories!
//                       .where((element) => (element.studentName ?? '')
//                           .toLowerCase()
//                           .contains(value.toLowerCase()))
//                       .toList();
//                   if (value.isEmpty) {
//                     listData.value.clear();
//                     listData.value = [
//                       ...HistoryHelper.convertHistoryToActivity(
//                           state.histories!, RoleHistory.supervisor, context,
//                           isCoordinator: true)
//                     ];
//                   } else {
//                     listData.value = [
//                       ...HistoryHelper.convertHistoryToActivity(
//                           data, RoleHistory.supervisor, context,
//                           isCoordinator: true)
//                     ];
//                   }
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
