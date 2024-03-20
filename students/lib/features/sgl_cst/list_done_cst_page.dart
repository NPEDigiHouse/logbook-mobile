import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:students/features/sgl_cst/list_sgl_page.skeleton.dart';
import 'package:students/features/sgl_cst/widgets/cst_submission_card.dart';

class ListDoneCstPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ListDoneCstPage({super.key, required this.activeDepartmentModel});

  @override
  State<ListDoneCstPage> createState() => _ListDoneCstPageState();
}

class _ListDoneCstPageState extends State<ListDoneCstPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)
        .getStudentCstDetail(status: "VERIFIED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SglCstCubit>(context)
                  .getStudentCstDetail(status: "VERIFIED")
            ]);
          },
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('List Verified CST'),
              ),
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
                                .getStudentSglDetail(status: "VERIFIED");
                          }
                        },
                        builder: (context, state) {
                          if (state.cstDoneDetail != null) {
                            if (state.cstDoneDetail!.csts!.isEmpty) {
                              return const Column(
                                children: [
                                  EmptyData(
                                      title: 'No CST Found',
                                      subtitle:
                                          'There is no cst data verified yet'),
                                ],
                              );
                            }
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data =
                                      state.cstDoneDetail!.csts![index];
                                  return CstSubmissionCard(
                                    activeDepartmentModel: widget.activeDepartmentModel,
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
                                itemCount: state.cstDoneDetail!.csts!.length);
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
