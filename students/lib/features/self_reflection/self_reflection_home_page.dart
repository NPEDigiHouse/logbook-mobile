import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/spacing_column.dart';
import 'create_self_reflection_page.dart';
import 'widgets/self_reflection_card.dart';

class StudentSelfReflectionHomePage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final UserCredential? credential;
  final bool isFromNotif;

  const StudentSelfReflectionHomePage(
      {super.key,
      this.isFromNotif = false,
      required this.activeDepartmentModel,
      this.credential});

  @override
  State<StudentSelfReflectionHomePage> createState() =>
      _StudentSelfReflectionHomePageState();
}

class _StudentSelfReflectionHomePageState
    extends State<StudentSelfReflectionHomePage> {
  @override
  void initState() {
    BlocProvider.of<StudentCubit>(context).getStudentSelfReflections();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfReflectionCubit, SelfReflectionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Self Reflections"),
          ),
          body: SafeArea(
            child: CheckInternetOnetime(child: (context) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    BlocProvider.of<StudentCubit>(context)
                        .getStudentSelfReflections(),
                  ]);
                },
                child: BlocListener<SelfReflectionCubit, SelfReflectionState>(
                  listener: (context, state) {
                    if (state.isDelete) {
                      BlocProvider.of<StudentCubit>(context)
                          .getStudentSelfReflections();
                      CustomAlert.success(
                          message: "Success Delete Self Reflection",
                          context: context);
                    }
                    if (state.isUpdate) {
                      BlocProvider.of<StudentCubit>(context)
                          .getStudentSelfReflections();
                      CustomAlert.success(
                          message: "Success Update Self Reflection",
                          context: context);
                    }
                    if (state.isSelfReflectionPostSuccess) {
                      CustomAlert.success(
                          message: "Success Add New Self Reflection",
                          context: context);
                    }
                  },
                  child: BlocBuilder<StudentCubit, StudentState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),
                          if (state.fetchSR == RequestState.loading)
                            const SliverFillRemaining(
                              child: CustomLoading(),
                            )
                          else if (state.selfReflectionResponse != null)
                            SliverToBoxAdapter(
                              child: SpacingColumn(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                onlyPading: true,
                                horizontalPadding: 16,
                                children: [
                                  DepartmentHeader(
                                      unitName: widget
                                              .activeDepartmentModel.unitName ??
                                          ''),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const ItemDivider(),
                                  if (widget.credential?.student
                                              ?.examinerDPKId ==
                                          null &&
                                      !widget.isFromNotif)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Please select a supervisor first in the profile menu before creating a self reflection',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: errorColor,
                                        ),
                                      ),
                                    ),
                                  if (widget.credential?.student
                                              ?.supervisingDPKId !=
                                          null ||
                                      widget.isFromNotif)
                                    _AddNewSelfReflectionCard(
                                      credential: widget.credential,
                                      isAlreadyCheckout: widget
                                                  .activeDepartmentModel
                                                  .checkOutTime !=
                                              null &&
                                          widget.activeDepartmentModel
                                                  .checkOutTime !=
                                              0,
                                    ),
                                  Builder(
                                    builder: (context) {
                                      if (state.selfReflectionResponse !=
                                          null) {
                                        final data = state
                                            .selfReflectionResponse!
                                            .listSelfReflections!;
                                        if (data.isEmpty) {
                                          return const EmptyData(
                                            subtitle:
                                                'Please add self reflection first!',
                                            title: 'Data Still Empty',
                                          );
                                        }
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) =>
                                                  StudentSelfReflectionCard(
                                                isAlreadyCheckout: widget
                                                            .activeDepartmentModel
                                                            .checkOutTime !=
                                                        null &&
                                                    widget.activeDepartmentModel
                                                            .checkOutTime !=
                                                        0,
                                                credential: widget.credential,
                                                isFromNotif: widget.isFromNotif,
                                                model: state
                                                        .selfReflectionResponse!
                                                        .listSelfReflections![
                                                    index],
                                                onUpdate: () {},
                                              ),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 16,
                                              ),
                                              itemCount: data.length,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              ),
                            )
                          else
                            const SliverFillRemaining(
                              child: CustomLoading(),
                            )
                        ],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _AddNewSelfReflectionCard extends StatelessWidget {
  final UserCredential? credential;
  final bool? isFromNotif;
  final bool isAlreadyCheckout;
  const _AddNewSelfReflectionCard(
      {super.key,
      this.credential,
      this.isFromNotif,
      this.isAlreadyCheckout = false});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: () {
        if (isAlreadyCheckout) {
          CustomAlert.error(
              message: "already checkout for this department",
              context: context);
          return;
        }
        context.navigateTo(CreateSelfReflectionPage(
          credential: credential,
          isFromNotif: isFromNotif ?? false,
        ));
      },
      color: primaryColor,
      boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 6,
            color: const Color(0xFFD4D4D4).withOpacity(.25)),
        BoxShadow(
            offset: const Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
            color: const Color(0xFFD4D4D4).withOpacity(.25)),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: Opacity(
                opacity: .3,
                child: SvgPicture.asset(
                  AssetPath.getVector('ellipse_1.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Opacity(
                opacity: .6,
                child: SvgPicture.asset(
                  AssetPath.getVector('half_ellipse.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Add self reflection',
                        style: textTheme.titleMedium?.copyWith(
                          color: scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Add a self-reflection for your activity',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.75),
                        ),
                      )
                    ],
                  )),
                  const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
