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
import 'package:students/features/sgl_cst/list_done_sgl_page.dart';
import 'package:students/features/sgl_cst/list_sgl_page.skeleton.dart';
import 'package:students/features/sgl_cst/widgets/sgl_submission_card.dart';
import 'create_sgl_page.dart';
import 'widgets/sgl_cst_app_bar.dart';

class ListSglPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ListSglPage({super.key, required this.activeDepartmentModel});

  @override
  State<ListSglPage> createState() => _ListSglPageState();
}

class _ListSglPageState extends State<ListSglPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)
        .getStudentSglDetail(status: "INPROCESS");
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
              current.isSglPostSuccess ||
              current.isSglEditSuccess ||
              current.isSglDeleteSuccess ||
              current.isNewTopicAddSuccess,
          listener: (context, state) {
            if (state.isSglPostSuccess) {
              CustomAlert.success(
                  message: 'Success Create new SGL', context: context);
            } else if (state.isSglEditSuccess) {
              CustomAlert.success(
                  message: 'Success Update SGL', context: context);
            } else if (state.isSglDeleteSuccess) {
              CustomAlert.success(
                  message: 'Success Delete SGL', context: context);
            } else if (state.isNewTopicAddSuccess) {
              CustomAlert.success(
                  message: 'Success add new topic SGL', context: context);
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
                    .getStudentSglDetail(status: "INPROCESS")
              ]);
            },
            child: CustomScrollView(
              slivers: [
                SglCstAppBar(
                    title: 'Small Group Learning (SGL)',
                    onBtnPressed: () {
                      context.navigateTo(
                        CreateSglPage(
                          model: widget.activeDepartmentModel,
                          date: DateTime.now(),
                        ),
                      );
                    },
                    onHistoryClick: () {
                      context.navigateTo(ListDoneSglPage(
                          activeDepartmentModel: widget.activeDepartmentModel));
                    }),
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
                            if (state.sglDetail != null) {
                              if ((state.sglDetail?.sgls ?? []).isEmpty) {
                                return const EmptyData(
                                    title: 'No SGL Found',
                                    subtitle: 'There is no sgl data added yet');
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data =
                                      (state.sglDetail?.sgls ?? [])[index];
                                  return SglSubmissionCard(
                                      data: data,
                                      unitId:
                                          widget.activeDepartmentModel.unitId ??
                                              '');
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                itemCount: (state.sglDetail?.sgls ?? []).length,
                              );
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
