import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'assesment_student_home_page.dart';

class SupervisorAssesmentStudentPage extends StatefulWidget {
  final UserCredential credential;
  const SupervisorAssesmentStudentPage({super.key, required this.credential});

  @override
  State<SupervisorAssesmentStudentPage> createState() =>
      _SupervisorAssesmentStudentPageState();
}

class _SupervisorAssesmentStudentPageState
    extends State<SupervisorAssesmentStudentPage> {
  ValueNotifier<List<SupervisorStudent>> listData = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<StudentCubit>(context)..getAllStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assesment'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            isMounted = false;
            await Future.wait(
                [BlocProvider.of<StudentCubit>(context).getAllStudents()]);
          },
          child: ValueListenableBuilder(
              valueListenable: listData,
              builder: (context, s, _) {
                return BlocConsumer<StudentCubit, StudentState>(
                  listener: (context, state) {
                    if (state.students != null) {
                      if (!isMounted) {
                        Future.microtask(() {
                          listData.value = [...state.students!];
                        });
                        isMounted = true;
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state.students != null) {
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
                                  final data = state.students!
                                      .where((element) => element.studentName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  if (value.isEmpty) {
                                    listData.value.clear();
                                    listData.value = [...state.students!];
                                  } else {
                                    listData.value = [...data];
                                  }
                                },
                                onClear: () {
                                  listData.value.clear();
                                  listData.value = [...state.students!];
                                },
                                text: '',
                                hint: 'Search student',
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
                                return _buildStudentCard(context, s[index]);
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

  Widget _buildStudentCard(BuildContext context, SupervisorStudent student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(AssesmentStudentHomePage(
        credential: widget.credential,
        studentId: student.studentId!,
        unitName: student.activeDepartmentName,
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
                if (student.userId == null) {
                  return CircleAvatar(
                    radius: 25,
                    foregroundImage: AssetImage(
                      AssetPath.getImage('profile_default.png'),
                    ),
                  );
                }
                return FutureBuilder(
                  future: BlocProvider.of<SupervisorsCubit>(context)
                      .getImageProfile(id: student.userId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomShimmer(
                          child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        width: 50,
                        height: 50,
                      ));
                    } else if (snapshot.hasData) {
                      student.profileImage = snapshot.data;
                      return CircleAvatar(
                        radius: 25,
                        foregroundImage: MemoryImage(snapshot.data!),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 25,
                        foregroundImage: AssetImage(
                          AssetPath.getImage('profile_default.png'),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
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
                const SizedBox(height: 8),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(
                      color: secondaryTextColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Active Department:\t',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: student.activeDepartmentName ??
                            'No Active Department',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
