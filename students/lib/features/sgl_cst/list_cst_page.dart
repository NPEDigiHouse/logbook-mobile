import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:students/features/sgl_cst/list_done_cst_page.dart';
import 'package:students/features/sgl_cst/list_sgl_page.skeleton.dart';
import 'package:students/features/sgl_cst/widgets/cst_submission_card.dart';
import 'create_cst_page.dart';
import 'widgets/sgl_cst_app_bar.dart';

class ListCstPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ListCstPage({super.key, required this.activeDepartmentModel});

  @override
  State<ListCstPage> createState() => _ListCstPageState();
}

class _ListCstPageState extends State<ListCstPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)
        .getStudentCstDetail(status: "INPROCESS");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SglCstCubit, SglCstState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            CustomAlert.error(message: state.errorMessage!, context: context);
          },
        ),
        BlocListener<SglCstCubit, SglCstState>(
          listenWhen: (previous, current) =>
              current.isCstPostSuccess ||
              current.isCstEditSuccess ||
              current.isCstDeleteSuccess ||
              current.isNewTopicAddSuccess,
          listener: (context, state) {
            if (state.isSglPostSuccess) {
              CustomAlert.success(
                  message: 'Success Create new CST', context: context);
            } else if (state.isSglEditSuccess) {
              CustomAlert.success(
                  message: 'Success Update CST', context: context);
            } else if (state.isSglDeleteSuccess) {
              CustomAlert.success(
                  message: 'Success Delete CST', context: context);
            } else if (state.isNewTopicAddSuccess) {
              CustomAlert.success(
                  message: 'Success add new topic CST', context: context);
            }
          },
        )
      ],
      child: Scaffold(
        body: CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<SglCstCubit>(context)
                    .getStudentCstDetail(status: "INPROCESS")
              ]);
            },
            child: CustomScrollView(
              slivers: [
                SglCstAppBar(
                  title: 'Clinical Skill Training (CST)',
                  onBtnPressed: () {
                    context.navigateTo(CreateCstPage(
                      model: widget.activeDepartmentModel,
                      date: DateTime.now(),
                    ));
                  },
                  onHistoryClick: () {
                    context.navigateTo(ListDoneCstPage(
                      activeDepartmentModel: widget.activeDepartmentModel,
                    ));
                  },
                ),
                SliverFillRemaining(
                  child: SingleChildScrollView(
                    child: SpacingColumn(
                      horizontalPadding: 16,
                      children: [
                        BlocBuilder<SglCstCubit, SglCstState>(
                          builder: (context, state) {
                            if (state.fetchState == RequestState.loading) {
                              return const ListSglCstPageSkeleton();
                            }
                            if (state.cstDetail != null) {
                              if (state.cstDetail!.csts!.isEmpty) {
                                return const Column(
                                  children: [
                                    EmptyData(
                                        title: 'No CST Found',
                                        subtitle:
                                            'There is no cst data added yet'),
                                  ],
                                );
                              }
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final data = state.cstDetail!.csts![index];
                                    return CstSubmissionCard(
                                        data: data,
                                        unitId: widget
                                                .activeDepartmentModel.unitId ??
                                            '');
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 16,
                                    );
                                  },
                                  itemCount: state.cstDetail!.csts!.length);
                            }

                            return const ListSglCstPageSkeleton();
                          },
                        ),
                        const SizedBox(
                          height: 16,
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
