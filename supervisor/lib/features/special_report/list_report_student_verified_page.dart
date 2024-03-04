import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/special_reports/special_report_on_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'widgets/special_report_student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSpecialReportVerifiedPage extends StatefulWidget {
  const SupervisorListSpecialReportVerifiedPage({super.key});

  @override
  State<SupervisorListSpecialReportVerifiedPage> createState() =>
      _SupervisorListSpecialReportVerifiedPageState();
}

class _SupervisorListSpecialReportVerifiedPageState
    extends State<SupervisorListSpecialReportVerifiedPage> {
  ValueNotifier<List<SpecialReportOnList>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<SpecialReportCubit>(context)
      ..getSpecialReportStudentsVerified());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: listStudent,
        builder: (context, s, _) {
          return BlocConsumer<SpecialReportCubit, SpecialReportState>(
              listener: (context, state) {
            if (state.specialReportStudentsVerified != null) {
              if (!isMounted) {
                Future.microtask(() {
                  listStudent.value = [...state.specialReportStudentsVerified!];
                });
                isMounted = true;
              }
            }
          }, builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Verified Problem Consultations'),
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
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              isSearchExpand.value = !value;

                              listStudent.value.clear();
                              listStudent.value = [
                                ...state.specialReportStudentsVerified!
                              ];
                            },
                            icon: const Icon(CupertinoIcons.search),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ).variant(),
              body: SafeArea(
                child: RefreshIndicator(onRefresh: () async {
                  isMounted = false;
                  await Future.wait([
                    BlocProvider.of<SpecialReportCubit>(context)
                        .getSpecialReportStudentsVerified(),
                  ]);
                }, child: Builder(
                  builder: (context) {
                    if (state.specialReportStudentsVerified == null) {
                      return const CustomLoading();
                    }
                    return ValueListenableBuilder(
                      valueListenable: isSearchExpand,
                      builder: (context, status, _) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Builder(builder: (context) {
                                  if (s.isEmpty) {
                                    return const EmptyData(
                                        title:
                                            'No Problem Consultations Submitted',
                                        subtitle:
                                            'wait for submission from students');
                                  }
                                  return CustomScrollView(
                                    slivers: [
                                      if (status)
                                        const SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: 68,
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
                                          return SpecialReportStudentCard(
                                            sr: s[index],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 12,
                                          );
                                        },
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                            if (status)
                              Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: scaffoldBackgroundColor,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              color: Colors.black12,
                                              blurRadius: 12,
                                              spreadRadius: 4)
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SearchField(
                                            onChanged: (value) {
                                              final data = state
                                                  .specialReportStudentsVerified!
                                                  .where((element) => element
                                                      .studentName!
                                                      .toLowerCase()
                                                      .contains(
                                                          value.toLowerCase()))
                                                  .toList();
                                              if (value.isEmpty) {
                                                listStudent.value.clear();
                                                listStudent.value = [
                                                  ...state
                                                      .specialReportStudentsVerified!
                                                ];
                                              } else {
                                                listStudent.value = [...data];
                                              }
                                            },
                                            onClear: () {
                                              listStudent.value.clear();
                                              listStudent.value = [
                                                ...state
                                                    .specialReportStudentsVerified!
                                              ];
                                            },
                                            text: '',
                                            hint: 'Search for student',
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
                        );
                      },
                    );
                  },
                )),
              ),
            );
          });
        });
  }
}