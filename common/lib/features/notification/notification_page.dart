import 'package:common/features/notification/utils/notif_item_helper.dart';
import 'package:common/features/notification/widgets/notification_card.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:supervisor/features/sgl_cst/widgets/select_department_sheet.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

enum UserRole { student, supervisor, coordinator }

class NotificationPage extends StatelessWidget {
  final UserRole role;
  const NotificationPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: _BuildNotificationPage(role: role),
    );
  }
}

class _BuildNotificationPage extends StatefulWidget {
  final UserRole role;
  const _BuildNotificationPage({super.key, required this.role});

  @override
  State<_BuildNotificationPage> createState() => _BuildNotificationPageState();
}

class _BuildNotificationPageState extends State<_BuildNotificationPage> {
  int page = 1;
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);
  String? query;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<NotificationCubit>(context)
        .getNotifications(page: page));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterNotifier>(builder: (context, ntf, _) {
      return BlocListener<NotificationCubit, NotificationState>(
        listenWhen: (previous, current) =>
            previous.isReadNotification != current.isReadNotification,
        listener: (context, state) {
          context.read<NotificationCubit>().getNotifications(page: 1);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              ValueListenableBuilder(
                valueListenable: isSearchExpand,
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      if (value)
                        Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                            )),
                      IconButton(
                        onPressed: () {
                          isSearchExpand.value = !value;
                        },
                        icon: const Icon(CupertinoIcons.search),
                      ),
                    ],
                  );
                },
              ),
              Stack(
                children: [
                  if (ntf.isActive)
                    Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        )),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        builder: (ctx) => SelectFilterSheet(
                          initUnit: ntf.unit,
                          filterType: ntf.activityType,
                          isUnreadOnly: ntf.isUnreadOnly,
                          onTap: (type, u, isUnread) {
                            // filterUnitId = f;
                            context.read<FilterNotifier>().setActivityType =
                                type;
                            context.read<FilterNotifier>().setDepartmentModel =
                                u;
                            context.read<FilterNotifier>().setUnreadOnlyStatus =
                                isUnread ?? false;
                            page = 1;
                            BlocProvider.of<NotificationCubit>(context)
                                .getNotifications(
                              unitId: u?.id,
                              query: query,
                              page: page,
                              activityType:
                                  NotifiItemHelper.getActivityTypeReverse[type],
                              isUnread: isUnread == false ? null : true,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
              child: RefreshIndicator(
                  child: BlocSelector<NotificationCubit, NotificationState,
                          (List<NotificationModel>?, RequestState)>(
                      selector: (state) =>
                          (state.notification, state.fetchState),
                      builder: (context, state) {
                        final data = state.$1;
                        if (data == null || state.$2 == RequestState.loading) {
                          return const CustomLoading();
                        }

                        return ValueListenableBuilder(
                            valueListenable: isSearchExpand,
                            builder: (context, status, _) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned.fill(child: Builder(
                                      builder: (context) {
                                        if (data.isNotEmpty) {
                                          return CustomScrollView(
                                            slivers: [
                                              if (status)
                                                const SliverToBoxAdapter(
                                                  child: SizedBox(
                                                    height: 64,
                                                  ),
                                                ),
                                              const SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: 16,
                                                ),
                                              ),
                                              SliverGroupedListView<
                                                  NotificationModel, DateTime>(
                                                groupBy: (element) => DateTime(
                                                  element.createdAt!.year,
                                                  element.createdAt!.month,
                                                  element.createdAt!.day,
                                                ),
                                                groupComparator:
                                                    (date1, date2) =>
                                                        date2.compareTo(date1),
                                                elements: data,
                                                itemBuilder:
                                                    (context, element) {
                                                  return NotificationCard(
                                                      activityType:
                                                          NotifiItemHelper
                                                                  .getActivityType[
                                                              element.type]!,
                                                      role: widget.role,
                                                      notification: element);
                                                },
                                                groupSeparatorBuilder: (date) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        NotifiItemHelper
                                                            .getTimeAgo(date),
                                                        style: textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                          );
                                        }
                                        return const EmptyData(
                                            title: 'Empty Notification',
                                            subtitle:
                                                'there is no notification yet');
                                      },
                                    )),
                                    if (status)
                                      Column(
                                        children: [
                                          Container(
                                            color: scaffoldBackgroundColor,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                SizedBox(
                                                  child: SearchField(
                                                    onClear: () {
                                                      query = null;
                                                      context
                                                          .read<
                                                              NotificationCubit>()
                                                          .getNotifications(
                                                              unitId:
                                                                  ntf.unit?.id,
                                                              page: page,
                                                              query: query,
                                                              activityType:
                                                                  NotifiItemHelper
                                                                          .getActivityTypeReverse[
                                                                      ntf
                                                                          .activityType],
                                                              isUnread:
                                                                  ntf.isUnreadOnly ==
                                                                          false
                                                                      ? null
                                                                      : true,
                                                              withLoading:
                                                                  false);
                                                    },
                                                    onChanged: (value) {
                                                      query = value;
                                                      context
                                                          .read<
                                                              NotificationCubit>()
                                                          .getNotifications(
                                                              unitId:
                                                                  ntf.unit?.id,
                                                              page: page,
                                                              query: query,
                                                              activityType:
                                                                  NotifiItemHelper
                                                                          .getActivityTypeReverse[
                                                                      ntf
                                                                          .activityType],
                                                              isUnread:
                                                                  ntf.isUnreadOnly ==
                                                                          false
                                                                      ? null
                                                                      : true,
                                                              withLoading:
                                                                  false);
                                                    },
                                                    text: '',
                                                    hint: 'Search student',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            });
                      }),
                  onRefresh: () async {})),
        ),
      );
    });
  }
}
