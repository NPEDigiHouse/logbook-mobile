import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'add_mini_cex_page.dart';
import 'student_mini_cex_detail.dart';

class StudentTestGrade extends StatefulWidget {
  final String unitName;
  final bool isExaminerDPKExist;

  const StudentTestGrade(
      {super.key, required this.unitName, required this.isExaminerDPKExist});

  @override
  State<StudentTestGrade> createState() => _StudentTestGradeState();
}

class _StudentTestGradeState extends State<StudentTestGrade> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context).getStudentMiniCexs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Cex"),
      ).variant(),
      body: Builder(builder: (context) {
        return CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
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
                                const SizedBox(
                                  height: 16,
                                ),
                                if (!widget.isExaminerDPKExist)
                                  Text(
                                    'Please select examiner dpk before upload mini cex data',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: errorColor,
                                    ),
                                  ),
                                const EmptyData(
                                    title: 'Empty Data',
                                    subtitle:
                                        'Please upload mini cex data before!'),
                                const SizedBox(
                                  height: 12,
                                ),
                                Center(
                                  child: FilledButton(
                                    onPressed: widget.isExaminerDPKExist
                                        ? () =>
                                            context.navigateTo(AddMiniCexPage(
                                              unitName: widget.unitName,
                                            ))
                                        : null,
                                    child: const Text('Add Mini Cex'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final miniCex = state.studentMiniCexs!.first;
                        return WrapperMiniCex(
                          id: miniCex.id!,
                        );
                      } else {
                        return const CustomLoading();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}

class WrapperMiniCex extends StatefulWidget {
  final String id;
  const WrapperMiniCex({super.key, required this.id});

  @override
  State<WrapperMiniCex> createState() => _WrapperMiniCexState();
}

class _WrapperMiniCexState extends State<WrapperMiniCex> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)
        .getMiniCexStudentDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.miniCexStudentDetail != null &&
            state.requestState == RequestState.data) {
          context.replace(StudentMiniCexDetail(
            id: widget.id,
          ));
        }
      },
      child: const CustomLoading(),
    );
  }
}
