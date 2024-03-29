import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_scientific_assignment_detail_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScientificAssignmentPage extends StatefulWidget {
  final String studentId;
  final String unitName;
  final String supervisorId;

  const ListScientificAssignmentPage({
    super.key,
    required this.unitName,
    required this.studentId,
    required this.supervisorId,
  });

  @override
  State<ListScientificAssignmentPage> createState() =>
      _ListScientificAssignmentPageState();
}

class _ListScientificAssignmentPageState
    extends State<ListScientificAssignmentPage> {
  @override
  void initState() {
    BlocProvider.of<AssesmentCubit>(context)
      ..studentScientificAssignment(studentId: widget.studentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scientific Assignments"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context)
                .studentScientificAssignment(studentId: widget.studentId),
          ]);
        },
        child: BlocConsumer<AssesmentCubit, AssesmentState>(
          listener: (context, state) {
            if (state.scientificAssignmentStudents != null &&
                state.scientificAssignmentStudents!.isNotEmpty) {
              context.replace(SupervisorScientificAssignmentDetailPage(
                  unitName: widget.unitName,
                  id: state.scientificAssignmentStudents!.first.id!,
                  supervisorId: widget.supervisorId));
            }
          },
          builder: (context, state) {
            if (state.scientificAssignmentStudents != null &&
                state.scientificAssignmentStudents!.isEmpty) {
              return EmptyData(
                title: 'No Data',
                subtitle: 'student have not yet upload scientific assignment',
              );
            }
            return CustomLoading();
          },
        ),
      ),
    );
  }
}
