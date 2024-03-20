import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/scientific_session/student_scientific_session_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'add_scientific_session_page.dart';
import 'widgets/scientific_session_card.dart';

class StudentListScientificSessionPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const StudentListScientificSessionPage(
      {super.key, required this.activeDepartmentModel});

  @override
  State<StudentListScientificSessionPage> createState() =>
      _StudentListScientificSessionPageState();
}

class _StudentListScientificSessionPageState
    extends State<StudentListScientificSessionPage> {
  ValueNotifier<List<StudentScientificSessionModel>> listData =
      ValueNotifier([]);
  bool isMounted = false;
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);
    BlocProvider.of<StudentCubit>(context)
        .getStudentScientificSessionOfActiveDepartment();
    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _selectedMenu.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScientificSessionCubit, ScientifcSessionState>(
      listenWhen: (previous, current) =>
          previous.isDeleteScientificSession !=
              current.isDeleteScientificSession ||
          previous.postSuccess != current.postSuccess,
      listener: (context, state) {
        isMounted = false;
        if (state.postSuccess) {
          CustomAlert.success(
              message: 'Success Add New Scoemtofoc Session', context: context);
        }
        if (state.isDeleteScientificSession) {
          CustomAlert.success(
              message: 'Success Delete Scientific Session', context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Scientific Session"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.activeDepartmentModel.checkOutTime != null && widget.activeDepartmentModel.checkOutTime != 0) {
              CustomAlert.error(
                  message: "already checkout for this department",
                  context: context);
              return;
            }
            context.navigateTo(AddScientificSessionPage(
                activeDepartmentModel: widget.activeDepartmentModel));
          },
          child: const Icon(
            Icons.add_rounded,
          ),
        ),
        // : null,
        body: SafeArea(
          child: CheckInternetOnetime(child: (context) {
            return RefreshIndicator(
              onRefresh: () async {
                isMounted = false;
                await Future.wait([
                  BlocProvider.of<StudentCubit>(context)
                      .getStudentScientificSessionOfActiveDepartment(),
                ]);
              },
              child: ValueListenableBuilder(
                  valueListenable: listData,
                  builder: (context, s, _) {
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          sliver: SliverFillRemaining(
                            child: BlocListener<ScientificSessionCubit,
                                ScientifcSessionState>(
                              listener: (context, state) async {
                                if (state.postSuccess) {
                                  isMounted = false;
                                  await Future.wait([
                                    BlocProvider.of<StudentCubit>(context)
                                        .getStudentScientificSessionOfActiveDepartment(),
                                  ]);
                                }
                              },
                              child: BlocConsumer<StudentCubit, StudentState>(
                                listener: (context, state) {
                                  if (state.scientificSessionResponse != null &&
                                      state.ssState == RequestState.data) {
                                    if (!isMounted) {
                                      Future.microtask(() {
                                        listData.value = [
                                          ...state.scientificSessionResponse!
                                              .listScientificSessions!
                                        ];
                                        isMounted = true;
                                      });
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  if (state.ssState == RequestState.loading) {
                                    return const CustomLoading();
                                  } else if (state.scientificSessionResponse !=
                                      null) {
                                    return SingleChildScrollView(
                                      child: SpacingColumn(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        onlyPading: true,
                                        horizontalPadding: 16,
                                        children: [
                                          DepartmentHeader(
                                              unitName: widget
                                                  .activeDepartmentModel
                                                  .unitName!),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          const ItemDivider(),
                                          Builder(
                                            builder: (context) {
                                              if (state
                                                      .scientificSessionResponse !=
                                                  null) {
                                                return Column(
                                                  children: [
                                                    // SizedBox(
                                                    //   height: 16,
                                                    // ),
                                                    buildSearchFilterSection(
                                                      verifiedCount: state
                                                          .scientificSessionResponse!
                                                          .verifiedCounts!,
                                                      unverifiedCount: state
                                                          .scientificSessionResponse!
                                                          .unverifiedCounts!,
                                                    ),
                                                    Builder(builder: (context) {
                                                      if (s.isEmpty) {
                                                        return const EmptyData(
                                                          subtitle:
                                                              'Please upload scientific session data first!',
                                                          title:
                                                              'Data Still Empty',
                                                        );
                                                      }
                                                      return ListView.separated(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder: (context,
                                                                index) =>
                                                            StudentScientificSessionCard(
                                                          onUpdate: () {
                                                            isMounted = false;
                                                            BlocProvider.of<
                                                                        StudentCubit>(
                                                                    context)
                                                                .getStudentScientificSessionOfActiveDepartment();
                                                          },
                                                          department: widget
                                                              .activeDepartmentModel,
                                                          model: s[index],
                                                        ),
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const SizedBox(
                                                                    height: 12),
                                                        itemCount: s.length,
                                                      );
                                                    }),
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return const CustomLoading();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }),
        ),
      ),
    );
  }

  ValueListenableBuilder<Map<String, String>?> buildSearchFilterSection(
      {required int verifiedCount, required int unverifiedCount}) {
    final menuList = [
      'All',
      '$verifiedCount Verified',
      '$unverifiedCount Unverified',
    ];
    return ValueListenableBuilder(
      valueListenable: _dataFilters,
      builder: (context, data, value) {
        return BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: menuList.length,
                    itemBuilder: (context, index) {
                      return ValueListenableBuilder(
                        valueListenable: _selectedMenu,
                        builder: (context, value, child) {
                          final selected = value == menuList[index];
                          return RawChip(
                            pressElevation: 0,
                            clipBehavior: Clip.antiAlias,
                            label: Text(menuList[index]),
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            labelStyle: textTheme.bodyMedium?.copyWith(
                              color: selected ? primaryColor : primaryTextColor,
                            ),
                            side: BorderSide(
                              color:
                                  selected ? Colors.transparent : borderColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            checkmarkColor: primaryColor,
                            selectedColor: primaryColor.withOpacity(.2),
                            selected: selected,
                            onSelected: (_) {
                              _selectedMenu.value = menuList[index];
                              switch (index) {
                                case 0:
                                  listData.value = [
                                    ...state.scientificSessionResponse!
                                        .listScientificSessions!
                                  ];
                                  break;
                                case 1:
                                  listData.value = [
                                    ...state.scientificSessionResponse!
                                        .listScientificSessions!
                                        .where((element) =>
                                            element.verificationStatus ==
                                            'VERIFIED')
                                        .toList()
                                  ];
                                  break;
                                case 2:
                                  listData.value = [
                                    ...state.scientificSessionResponse!
                                        .listScientificSessions!
                                        .where((element) =>
                                            element.verificationStatus !=
                                            'VERIFIED')
                                        .toList()
                                  ];
                                  break;
                                default:
                              }
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
