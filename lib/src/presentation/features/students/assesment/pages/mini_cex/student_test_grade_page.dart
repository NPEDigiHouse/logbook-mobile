import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/add_mini_cex_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_mini_cex_detail.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/title_assesment_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentTestGrade extends StatefulWidget {
  final String unitName;
  const StudentTestGrade({super.key, required this.unitName});

  @override
  State<StudentTestGrade> createState() => _StudentTestGradeState();
}

class _StudentTestGradeState extends State<StudentTestGrade> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)..getStudentMiniCexs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Cex"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context).getStudentMiniCexs(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: BlocBuilder<AssesmentCubit, AssesmentState>(
                builder: (context, state) {
                  if (state.studentMiniCexs != null) {
                    if (state.studentMiniCexs!.isEmpty) {
                      return SingleChildScrollView(
                        child: SpacingColumn(
                          onlyPading: true,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          horizontalPadding: 16,
                          spacing: 12,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            EmptyData(
                                title: 'Empty Data',
                                subtitle:
                                    'Please upload mini cex data before!'),
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
                        ),
                      );
                    }
                    final miniCex = state.studentMiniCexs!.first;
                    return SpacingColumn(
                      onlyPading: true,
                      horizontalPadding: 16,
                      spacing: 12,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        TitleAssesmentCard(
                          title: miniCex.miniCexListModelCase ?? '',
                          subtitle: miniCex.location ?? '',
                        ),
                        StudentMiniCexDetail(id: miniCex.id!),
                      ],
                    );
                  } else {
                    return CustomLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
