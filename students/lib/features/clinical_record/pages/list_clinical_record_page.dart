import 'package:common/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/clinical_records/student_clinical_record_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'create_clinical_record_first_page.dart';
import '../widgets/clinical_record_card.dart';

class ListClinicalRecordPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ListClinicalRecordPage(
      {super.key, required this.activeDepartmentModel});

  @override
  State<ListClinicalRecordPage> createState() => _ListClinicalRecordPageState();
}

class _ListClinicalRecordPageState extends State<ListClinicalRecordPage> {
  ValueNotifier<List<StudentClinicalRecordModel>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);
    BlocProvider.of<StudentCubit>(context)
        .getStudentClinicalRecordOfActiveDepartment();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinical Records"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.navigateTo(CreateClinicalRecordFirstPage(
              activeDepartmentModel: widget.activeDepartmentModel));
          isMounted = false;
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              isMounted = false;
              await Future.wait([
                BlocProvider.of<StudentCubit>(context)
                    .getStudentClinicalRecordOfActiveDepartment(),
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
                          child: BlocListener<ClinicalRecordCubit,
                              ClinicalRecordState>(
                            listener: (context, state) {
                              if (state.clinicalRecordPostSuccess) {
                                isMounted = false;
                              }
                            },
                            child: BlocConsumer<StudentCubit, StudentState>(
                              listener: (context, state) {
                                if (state.clinicalRecordResponse != null &&
                                    state.crState == RequestState.data) {
                                  if (!isMounted) {
                                    Future.microtask(() {
                                      listData.value = [
                                        ...state.clinicalRecordResponse!
                                            .listClinicalRecords!
                                      ];
                                      isMounted = true;
                                    });
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state.requestState ==
                                    RequestState.loading) {
                                  return const CustomLoading();
                                } else if (state.clinicalRecordResponse !=
                                        null &&
                                    state.clinicalRecordResponse
                                            ?.listClinicalRecords !=
                                        null) {
                                  if (state.clinicalRecordResponse!
                                      .listClinicalRecords!.isEmpty) {
                                    return const EmptyData(
                                      title: 'Clinical Record Empty',
                                      subtitle:
                                          'Please upload clinical record before',
                                    );
                                  }
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
                                            if (state.clinicalRecordResponse !=
                                                null) {
                                              final data = state
                                                  .clinicalRecordResponse!
                                                  .listClinicalRecords!;
                                              if (data.isEmpty) {
                                                return const EmptyData(
                                                  subtitle:
                                                      'Please upload clinical record data first!',
                                                  title: 'Data Still Empty',
                                                );
                                              }
                                              return Column(
                                                children: [
                                                  buildSearchFilterSection(
                                                    verifiedCount: state
                                                        .clinicalRecordResponse!
                                                        .verifiedCounts!,
                                                    unverifiedCount: state
                                                        .clinicalRecordResponse!
                                                        .unverifiedCounts!,
                                                  ),
                                                  ListView.separated(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            ClinicalRecordCard(
                                                      model: s[index],
                                                    ),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                                height: 12),
                                                    itemCount: s.length,
                                                  ),
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
                                return const SizedBox.shrink();
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
                                    ...state.clinicalRecordResponse!
                                        .listClinicalRecords!
                                  ];
                                  break;
                                case 1:
                                  listData.value = [
                                    ...state.clinicalRecordResponse!
                                        .listClinicalRecords!
                                        .where((element) =>
                                            element.verificationStatus ==
                                            'VERIFIED')
                                        .toList()
                                  ];
                                  break;
                                case 2:
                                  listData.value = [
                                    ...state.clinicalRecordResponse!
                                        .listClinicalRecords!
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
