import 'package:common/features/notification/utils/notif_item_helper.dart';
import 'package:common/features/notification/widgets/notification_card.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

enum NotificationRole { student, supervisor, coordinator }

class NotificationPage extends StatefulWidget {
  final NotificationRole role;
  const NotificationPage({super.key, required this.role});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int page = 1;
  String? query;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() => BlocProvider.of<NotificationCubit>(context)
        .getNotifications(page: page));
  }

  void _onScroll() {
    final state = context.read<NotificationCubit>().state.fetchState;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    // BlocProvider.of<NotificationCubit>(context).getNotifications(
    //     unitId: d.unit?.id,
    //     query: query,
    //     page: page + 1,
    //     onScroll: true,
    //     type: d.filterType);
    page++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
          ),
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
              child: BlocSelector<NotificationCubit, NotificationState,
                  (List<NotificationModel>?, RequestState)>(
                selector: (state) => (state.notification, state.fetchState),
                builder: (context, state) {
                  final data = state.$1;
                  if (data == null || state.$2 == RequestState.loading) {
                    return const CustomLoading();
                  }
                  if (data.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverGroupedListView<NotificationModel, DateTime>(
                            groupBy: (element) => DateTime(
                              element.createdAt!.year,
                              element.createdAt!.month,
                              element.createdAt!.day,
                            ),
                            groupComparator: (date1, date2) =>
                                date2.compareTo(date1),
                            elements: data,
                            itemBuilder: (context, element) {
                              return NotificationCard(
                                  activityType: NotifiItemHelper
                                      .getActivityType[element.type]!,
                                  role: widget.role,
                                  notification: element);
                            },
                            groupSeparatorBuilder: (date) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    NotifiItemHelper.getTimeAgo(date),
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separator: const SizedBox(
                              height: 20,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const EmptyData(
                        title: 'Empty Notification',
                        subtitle: 'there is no notification yet');
                  }
                },
              ),
              onRefresh: () async {})),
    );
  }
}
