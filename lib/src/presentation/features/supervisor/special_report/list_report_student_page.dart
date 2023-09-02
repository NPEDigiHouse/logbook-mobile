import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_on_list.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/special_report/widgets/special_report_student_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSpecialReportPage extends StatefulWidget {
  const SupervisorListSpecialReportPage({super.key});

  @override
  State<SupervisorListSpecialReportPage> createState() =>
      _SupervisorListSpecialReportPageState();
}

class _SupervisorListSpecialReportPageState
    extends State<SupervisorListSpecialReportPage> {
  ValueNotifier<List<SpecialReportOnList>> listStudent = ValueNotifier([]);
  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<SpecialReportCubit>(context)
      ..getSpecialReportStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Reports'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SpecialReportCubit>(context)
                  .getSpecialReportStudents(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocConsumer<SpecialReportCubit, SpecialReportState>(
                  listener: (context, state) {
                    if (state.specialReportStudents != null) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listStudent.value = [...state.specialReportStudents!];
                        });
                        isMounted = true;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state.specialReportStudents == null) {
                      return CustomLoading();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SearchField(
                              onChanged: (value) {
                                final data = state.specialReportStudents!
                                    .where((element) => element.studentName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                if (value.isEmpty) {
                                  listStudent.value.clear();
                                  listStudent.value = [
                                    ...state.specialReportStudents!
                                  ];
                                } else {
                                  listStudent.value = [...data];
                                }
                              },
                              text: '',
                              hint: 'Search for student',
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 12,
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
                              return SizedBox(
                                height: 12,
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
