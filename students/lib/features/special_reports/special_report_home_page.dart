import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:students/features/special_reports/widgets/add_new_consultion_card.dart';
import 'widgets/special_report_card.dart';

class SpecialReportHomePage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final UserCredential credential;

  const SpecialReportHomePage(
      {super.key,
      required this.activeDepartmentModel,
      required this.credential});

  @override
  State<SpecialReportHomePage> createState() => _SpecialReportHomePageState();
}

class _SpecialReportHomePageState extends State<SpecialReportHomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpecialReportCubit>(context).getStudentSpecialReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Problem Constultation"),
      ),
      body: SafeArea(
        child: CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<SpecialReportCubit>(context)
                    .getStudentSpecialReport(),
              ]);
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: SpacingColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      onlyPading: true,
                      horizontalPadding: 16,
                      children: [
                        DepartmentHeader(
                          unitName: widget.activeDepartmentModel.unitName!,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (widget.credential.student?.supervisingDPKId == null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Please select a supervisor first in the profile menu before creating a self reflection',
                              style: textTheme.bodyMedium?.copyWith(
                                color: errorColor,
                              ),
                            ),
                          ),
                        if (widget.credential.student?.supervisingDPKId != null)
                          const AddNewConsultationCard(),
                        BlocBuilder<SpecialReportCubit, SpecialReportState>(
                          builder: (context, state) {
                            if (state.specialReport != null) {
                              if (state.specialReport!.listProblemConsultations!
                                  .isEmpty) {
                                return const EmptyData(
                                    title: 'No Problem Consultation Data',
                                    subtitle:
                                        'Please upload the problem consultation first');
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'List of Consultation on Encountered Issues',
                                    style: textTheme.titleMedium?.copyWith(
                                      height: 1.1,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ListView.separated(
                                    itemBuilder: (context, index) {
                                      return SpecialReportCard(
                                        data: state.specialReport!
                                            .listProblemConsultations![index],
                                        index: index + 1,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 12,
                                      );
                                    },
                                    itemCount: state.specialReport!
                                        .listProblemConsultations!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox(
                                height: 300, child: CustomLoading());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
