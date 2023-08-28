import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_personal_behavior_detail_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_scientific_assignment_detail_page.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPersonalBehaviorPage extends StatefulWidget {
  final String studentId;
  final String unitName;
  const ListPersonalBehaviorPage(
      {super.key, required this.unitName, required this.studentId});

  @override
  State<ListPersonalBehaviorPage> createState() =>
      _ListPersonalBehaviorPageState();
}

class _ListPersonalBehaviorPageState extends State<ListPersonalBehaviorPage> {
  @override
  void initState() {
    BlocProvider.of<AssesmentCubit>(context)
      ..getPersonalBehaviorByStudentId(studentId: widget.studentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Behavior Grade"),
      ).variant(),
      body: BlocConsumer<AssesmentCubit, AssesmentState>(
        listener: (context, state) {
          if (state.personalBehaviorStudent != null &&
              state.personalBehaviorStudent!.isNotEmpty) {
            context.replace(SupervisorPersonalBehaviorDetailPage(
                unitName: '', id: state.personalBehaviorStudent!.first.id!));
          }
        },
        builder: (context, state) {
          if (state.personalBehaviorStudent != null &&
              state.personalBehaviorStudent!.isEmpty) {
            return EmptyData(
              title: 'No Data',
              subtitle: 'no personal behavior data',
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
