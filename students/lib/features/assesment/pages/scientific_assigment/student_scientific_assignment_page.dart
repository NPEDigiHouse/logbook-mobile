import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'add_scientific_assignment_page.dart';
import 'student_scientific_assignment_detail.dart';

class StudentScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  final bool isSupervisingDPKExist;
  final bool isAlreadyCheckOut;
  const StudentScientificAssignmentPage(
      {super.key,
      required this.unitName,
      required this.isSupervisingDPKExist,
      this.isAlreadyCheckOut = false});

  @override
  State<StudentScientificAssignmentPage> createState() =>
      _StudentScientificAssignmentPageState();
}

class _StudentScientificAssignmentPageState
    extends State<StudentScientificAssignmentPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context).getStudentScientificAssignment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Assignment"),
      ).variant(),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<AssesmentCubit>(context)
                  .getStudentScientificAssignment(),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: BlocBuilder<AssesmentCubit, AssesmentState>(
                  builder: (context, state) {
                    if (state.scientificAssignmentStudents != null) {
                      if (state.scientificAssignmentStudents!.isEmpty) {
                        return SingleChildScrollView(
                          child: SpacingColumn(
                            onlyPading: true,
                            mainAxisAlignment: MainAxisAlignment.center,
                            horizontalPadding: 16,
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              if (!widget.isSupervisingDPKExist)
                                Text(
                                  'Please select supervising dpk before upload scientific assignment data',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: errorColor,
                                  ),
                                ),
                              const EmptyData(
                                  title: 'Empty Data',
                                  subtitle:
                                      'Please upload scientific assignment data before!'),
                              const SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: FilledButton(
                                  onPressed: widget.isSupervisingDPKExist
                                      ? () => context.navigateTo(
                                              AddScientificAssignmentPage(
                                            unitName: widget.unitName,
                                          ))
                                      : null,
                                  child:
                                      const Text('Add Scientific Assignment'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final sa = state.scientificAssignmentStudents!.first;
                      return WrapperScientificAssignment(id: sa.id!, isAlreadyCheckout: widget.isAlreadyCheckOut);
                    } else {
                      return const CustomLoading();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class WrapperScientificAssignment extends StatefulWidget {
  final String id;
  final bool isAlreadyCheckout;
  const WrapperScientificAssignment(
      {super.key, required this.id, required this.isAlreadyCheckout});

  @override
  State<WrapperScientificAssignment> createState() =>
      _WrapperScientificAssignmentState();
}

class _WrapperScientificAssignmentState
    extends State<WrapperScientificAssignment> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)
        .getScientiicAssignmentDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.scientificAssignmentDetail != null) {
          context.replace(
            ScientificAssignmentDetail(
                id: widget.id, isAlreadyCheckOut: widget.isAlreadyCheckout),
          );
        }
      },
      child: const CustomLoading(),
    );
  }
}
