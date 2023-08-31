import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/student_unit_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListStudentUnitPage extends StatefulWidget {
  const SupervisorListStudentUnitPage({super.key});

  @override
  State<SupervisorListStudentUnitPage> createState() =>
      _SupervisorListStudentUnitPageState();
}

class _SupervisorListStudentUnitPageState
    extends State<SupervisorListStudentUnitPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<SupervisorsCubit>(context)..getAllStudentUnit());
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
              BlocProvider.of<SupervisorsCubit>(context).getAllStudentUnit(),
            ]);
          },
          child: BlocBuilder<SupervisorsCubit, SupervisorsState>(
            builder: (context, state) {
              if (state is Loading) {
                return CustomLoading();
              }
              if (state is FetchStudentUnitSuccess)
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
                          onChanged: (value) {},
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
                        itemCount: state.students.length,
                        itemBuilder: (context, index) {
                          return StudentUnitCard(
                            data: state.students[index],
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
          ),
        ),
      ),
    );
  }
}
