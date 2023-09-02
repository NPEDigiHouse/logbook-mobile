import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/custom_shimmer.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyActivityListStudentPage extends StatefulWidget {
  const DailyActivityListStudentPage({super.key});

  @override
  State<DailyActivityListStudentPage> createState() =>
      _DailyActivityListStudentPageState();
}

class _DailyActivityListStudentPageState
    extends State<DailyActivityListStudentPage> {
  ValueNotifier<List<SupervisorStudent>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => BlocProvider.of<SupervisorsCubit>(context)..getAllStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SupervisorsCubit>(context).getAllStudents(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocConsumer<SupervisorsCubit, SupervisorsState>(
                  listener: (context, state) {
                    if (state is FetchStudentSuccess) {
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
                    if (state is Error) {
                      return Center(
                        child: Text('Error'),
                      );
                    }

                    if (state is FetchStudentSuccess) {
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
                                  final data = state.students!
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

  Widget _buildStudentCard(BuildContext context, SupervisorStudent student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(SupervisorDailyActivityPage(
        studentId: student.studentId!,
      )),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              if (student.profileImage != null) {
                return CircleAvatar(
                  radius: 25,
                  foregroundImage: MemoryImage(student.profileImage!),
                );
              } else {
                return FutureBuilder(
                  future: BlocProvider.of<SupervisorsCubit>(context)
                      .getImageProfile(id: student.userId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomShimmer(
                          child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        width: 50,
                        height: 50,
                      ));
                    } else if (snapshot.hasError) {
                      return CircleAvatar(
                        radius: 25,
                        foregroundImage: AssetImage(
                          AssetPath.getImage('profile_default.png'),
                        ),
                      );
                    } else {
                      student.profileImage = snapshot.data;
                      return CircleAvatar(
                        radius: 25,
                        foregroundImage: MemoryImage(snapshot.data!),
                      );
                    }
                  },
                );
              }
            },
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
            ],
          )
        ],
      ),
    );
  }
}
