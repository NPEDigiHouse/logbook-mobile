import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
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
    BlocProvider.of<SglCstCubit>(context).getStudentCstDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Clinical Skill Training (CST)'),
      // ),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait(
                [BlocProvider.of<SglCstCubit>(context).getStudentCstDetail()]);
          },
          child: CustomScrollView(
            slivers: [
              // if (widget.activeDepartmentModel.countCheckIn! == 0)
              SglCstAppBar(
                title: 'Clinical Skill Training (CST)',
                onBtnPressed: () {
                  context.navigateTo(CreateCstPage(
                    model: widget.activeDepartmentModel,
                    date: DateTime.now(),
                  ));
                },
              ),
              // else
              //   SliverToBoxAdapter(
              //     child: SizedBox(
              //       height: 16,
              //     ),
              //   ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: SpacingColumn(
                    horizontalPadding: 16,
                    children: [
                      BlocConsumer<SglCstCubit, SglCstState>(
                        listener: (context, state) {
                          if (state.isCstDeleteSuccess ||
                              state.isCstEditSuccess) {
                            BlocProvider.of<SglCstCubit>(context)
                                .getStudentSglDetail();
                          }
                        },
                        builder: (context, state) {
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
                                      data: data, widget: widget);
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
    );
  }
}
