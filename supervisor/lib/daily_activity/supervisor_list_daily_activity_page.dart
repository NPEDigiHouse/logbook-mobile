import 'package:core/context/navigation_extension.dart';
import 'package:data/models/daily_activity/daily_activity_student.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'widgets/daily_activity_card.dart';
import '../sgl_cst/widgets/select_department_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorStudentsDailyActivityPage extends StatefulWidget {
  const SupervisorStudentsDailyActivityPage({super.key});

  @override
  State<SupervisorStudentsDailyActivityPage> createState() =>
      _SupervisorStudentsDailyActivityPageState();
}

class _SupervisorStudentsDailyActivityPageState
    extends State<SupervisorStudentsDailyActivityPage> {
  String? filterUnitId;

  ValueNotifier<List<DailyActivityStudent>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    filterUnitId = null;
    isMounted = false;
    Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
      ..getDailyActivityStudentBySupervisor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted Daily Activity'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (ctx) => SelectDepartmentSheet(
                  initUnit: filterUnitId,
                  onTap: (f) {
                    filterUnitId = f;
                    isMounted = false;
                    BlocProvider.of<DailyActivityCubit>(context)
                        .getDailyActivityStudentBySupervisor(unitId: f);
                    Navigator.pop(context);
                  },
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.line_horizontal_3_decrease,
            ),
          )
        ],
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            isMounted = false;
            await Future.wait([
              BlocProvider.of<DailyActivityCubit>(context)
                  .getDailyActivityStudentBySupervisor(unitId: filterUnitId),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocConsumer<DailyActivityCubit, DailyActivityState>(
                  listener: (context, state) {
                    if (state.stateVerifyDailyActivity == RequestState.data) {
                      isMounted = false;
                      BlocProvider.of<DailyActivityCubit>(context)
                          .getDailyActivityStudentBySupervisor(
                              unitId: filterUnitId);
                    }
                  },
                  builder: (context, state) {
                    if (state.dailyActivityStudents != null &&
                        state.requestState == RequestState.data) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listStudent.value = [...state.dailyActivityStudents!];
                        });
                        isMounted = true;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 16,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SearchField(
                                onChanged: (value) {
                                  final data = state.dailyActivityStudents!
                                      .where((element) => element.studentName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  if (value.isEmpty) {
                                    listStudent.value.clear();
                                    listStudent.value = [
                                      ...state.dailyActivityStudents!
                                    ];
                                  } else {
                                    listStudent.value = [...data];
                                  }
                                },
                                text: 'Search',
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 16,
                              ),
                            ),
                            SliverList.separated(
                              itemCount: s.length,
                              itemBuilder: (context, index) {
                                return DailyActivityCard(
                                  dailyActivityStudent: s[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                            )
                          ],
                        ),
                      );
                    }

                    return const CustomLoading();
                  },
                );
              }),
        ),
      ),
    );
  }
}
