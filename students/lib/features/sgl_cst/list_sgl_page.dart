import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
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
    BlocProvider.of<SglCstCubit>(context).getStudentSglDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Small Group Learning (SGL)'),
      // ),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait(
                [BlocProvider.of<SglCstCubit>(context).getStudentSglDetail()]);
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
              ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: SpacingColumn(
                    horizontalPadding: 16,
                    children: [
                      BlocConsumer<SglCstCubit, SglCstState>(
                        listener: (context, state) {
                          if (state.isSglDeleteSuccess ||
                              state.isSglEditSuccess) {
                            BlocProvider.of<SglCstCubit>(context)
                                .getStudentSglDetail();
                          }
                        },
                        builder: (context, state) {
                          if (state.sglDetail != null) {
                            if (state.sglDetail!.sgls!.isEmpty) {
                              return const EmptyData(
                                  title: 'No SGL Found',
                                  subtitle: 'There is no sgl data added yet');
                            }
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data = state.sglDetail!.sgls![index];
                                  return SglSubmissionCard(
                                      data: data, widget: widget);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                itemCount: state.sglDetail!.sgls!.length);
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
