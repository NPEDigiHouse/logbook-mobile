import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListResidentPage extends StatefulWidget {
  const ListResidentPage({super.key});

  @override
  State<ListResidentPage> createState() => _ListResidentPageState();
}

class _ListResidentPageState extends State<ListResidentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<SupervisorsCubit>(context)..getAllStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SupervisorsCubit, SupervisorsState>(
          builder: (context, state) {
            if (state is Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is Error) {
              return Center(
                child: Text('Error'),
              );
            }
            if (state is FetchStudentSuccess)
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
                      child: Text(
                        'Students',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SearchField(
                        onChanged: (value) {},
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
                      itemCount: state.students.length,
                      itemBuilder: (context, index) {
                        return _buildStudentCard(
                            context, state.students[index]);
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
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, SupervisorStudent student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(ResidentMenuPage(
        student: student,
      )),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            foregroundImage: AssetImage(
              AssetPath.getImage('profile_default.png'),
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
            ],
          )
        ],
      ),
    );
  }
}
