import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/add_mini_cex_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_mini_cex_detail.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/title_assesment_card.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  const StudentScientificAssignmentPage({super.key, required this.unitName});

  @override
  State<StudentScientificAssignmentPage> createState() =>
      _StudentScientificAssignmentPageState();
}

class _StudentScientificAssignmentPageState
    extends State<StudentScientificAssignmentPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)..studentMiniCexs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scientific Assignment"),
      ).variant(),
      body: SingleChildScrollView(
        child: SpacingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            horizontalPadding: 16,
            spacing: 12,
            children: [
              SizedBox(
                height: 16,
              ),
              UnitHeader(unitName: widget.unitName),
              BlocBuilder<AssesmentCubit, AssesmentState>(
                builder: (context, state) {
                  if (state.studentMiniCexs != null) {
                    if (state.studentMiniCexs!.isEmpty) {
                      return SpacingColumn(
                        onlyPading: true,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          EmptyData(
                              title: 'Empty Data',
                              subtitle: 'Please upload mini cex data before!'),
                          SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: FilledButton(
                              onPressed: () =>
                                  context.navigateTo(AddMiniCexPage(
                                unitName: widget.unitName,
                              )),
                              child: Text('Add Mini Cex'),
                            ),
                          ),
                        ],
                      );
                    }
                    final miniCex = state.studentMiniCexs!.first;
                    return Column(
                      children: [
                        TitleAssesmentCard(
                          title: miniCex.miniCexListModelCase ?? '',
                          subtitle: miniCex.location ?? '',
                        ),
                        StudentMiniCexDetail(id: miniCex.id!),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ]),
      ),
    );
  }
}
