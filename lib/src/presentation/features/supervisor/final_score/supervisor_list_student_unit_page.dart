import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/student_unit_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListStudentDepartmentPage extends StatefulWidget {
  const SupervisorListStudentDepartmentPage({super.key});

  @override
  State<SupervisorListStudentDepartmentPage> createState() =>
      _SupervisorListStudentDepartmentPageState();
}

class _SupervisorListStudentDepartmentPageState
    extends State<SupervisorListStudentDepartmentPage> {
  ValueNotifier<List<StudentDepartmentModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  bool isLoad = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<SupervisorsCubit>(context)..getAllStudentDepartment());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Score'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SupervisorsCubit>(context)
                  .getAllStudentDepartment(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocConsumer<SupervisorsCubit, SupervisorsState>(
                  listener: (context, state) {
                    if (state is FetchStudentDepartmentSuccess) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listStudent.value = [...state.students];
                        });
                        isMounted = true;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return CustomLoading();
                    }
                    if (state is FetchStudentDepartmentSuccess)
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
                                  final data = state.students
                                      .where((element) => element.studentName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  if (value.isEmpty) {
                                    listStudent.value.clear();
                                    listStudent.value = [...state.students];
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
                                return StudentDepartmentCard(
                                  data: s[index],
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
                    return SizedBox.shrink();
                  },
                );
              }),
        ),
      ),
    );
  }
}
