import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/competences/student_competence_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/list_skills_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListStudentTasksPage extends StatefulWidget {
  const ListStudentTasksPage({
    super.key,
  });

  @override
  State<ListStudentTasksPage> createState() => _ListStudentTasksPageState();
}

class _ListStudentTasksPageState extends State<ListStudentTasksPage> {
  ValueNotifier<List<StudentCompetenceModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<CompetenceCubit>(context)..getSkillStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Skills'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            isMounted = false;
            await Future.wait([
              BlocProvider.of<CompetenceCubit>(context).getSkillStudents(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocBuilder<CompetenceCubit, CompetenceState>(
                  builder: (context, state) {
                    if (state.requestState == RequestState.loading &&
                        state.skillListStudent == null) {
                      return CustomLoading();
                    }
                    if (state.requestState == RequestState.error) {
                      return Center(
                        child: Text('Error'),
                      );
                    }
                    if (state.skillListStudent != null) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listStudent.value = [...state.skillListStudent!];
                        });
                        isMounted = true;
                      }
                      if (state.skillListStudent!.isEmpty) {
                        return EmptyData(
                            title: 'No Skills',
                            subtitle: 'nothing student upload cases');
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
                                  final data = state.skillListStudent!
                                      .where((element) => element.studentName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  if (value.isEmpty) {
                                    listStudent.value.clear();
                                    listStudent.value = [
                                      ...state.skillListStudent!
                                    ];
                                  } else {
                                    listStudent.value = [...data];
                                  }
                                },
                                text: '',
                                hint: 'Search student',
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 16,
                              ),
                            ),
                            SliverList.separated(
                              itemCount: s.length,
                              itemBuilder: (context, index) {
                                return _buildStudentCard(context, s[index]);
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
                    }

                    return SizedBox();
                  },
                );
              }),
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      BuildContext context, StudentCompetenceModel student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(
        SupervisorListSkillsPage(
            unitName: student.activeDepartmentName ?? '',
            studentId: student.studentId!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 68,
              height: 68,
              color: primaryColor.withOpacity(.1),
              child: Center(
                child: Icon(
                  Icons.back_hand_rounded,
                  color: primaryColor,
                  size: 28,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.studentName ?? '',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                student.studentId ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              Text(
                student.activeDepartmentName ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
