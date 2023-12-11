
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/competences/list_cases_model.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/widgets/chip_verified.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';

import 'widgets/verify_case_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListCasesPage extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String unitName;
  const SupervisorListCasesPage({
    super.key,
    required this.studentName,
    required this.unitName,
    required this.studentId,
  });

  @override
  State<SupervisorListCasesPage> createState() =>
      _SupervisorListCasesPageState();
}

class _SupervisorListCasesPageState extends State<SupervisorListCasesPage> {
  ValueNotifier<List<CaseModel>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    // _menuList = [
    //   'All',
    //   'Verified',
    //   'Unverified',
    // ];

    Future.microtask(() {
      BlocProvider.of<CompetenceCubit>(context)
        .getCasesByStudentId(
          studentId: widget.studentId,
        );
    });

    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);

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
    return BlocConsumer<CompetenceCubit, CompetenceState>(
      listener: (context, state) {
        if (state.isCaseSuccessVerify || state.isAllCasesSuccessVerify) {
          BlocProvider.of<CompetenceCubit>(context)
            .getCasesByStudentId(
              studentId: widget.studentId,
            );
          isMounted = false;
        }
        if (state.listCasesModel != null &&
            !isMounted &&
            state.requestState == RequestState.data) {
          listData.value = [...state.listCasesModel!.listCases!];
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("List Cases"),
          ),
          floatingActionButton: SizedBox(
            width: AppSize.getAppWidth(context) - 32,
            child: state.listCasesModel != null &&
                    state.listCasesModel!.listCases!.indexWhere((element) =>
                            element.verificationStatus == 'INPROCESS') !=
                        -1
                ? FilledButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierLabel: '',
                          barrierDismissible: false,
                          builder: (_) => VerifyDialog(
                                onTap: () {
                                  BlocProvider.of<CompetenceCubit>(context)
                                    .verifyAllCaseOfStudent(
                                        studentId: widget.studentId);
                                  Navigator.pop(context);
                                },
                              ));
                    },
                    child: const Text('Verify All Cases'),
                  )
                : null,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                isMounted = false;
                await Future.wait([
                  BlocProvider.of<CompetenceCubit>(context).getCasesByStudentId(
                    studentId: widget.studentId,
                  ),
                ]);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: ValueListenableBuilder(
                      valueListenable: listData,
                      builder: (context, s, _) {
                        if (state.listCasesModel != null &&
                            state.requestState == RequestState.data) {
                          if (!isMounted) {
                            Future.microtask(() {
                              listData.value = [
                                ...state.listCasesModel!.listCases!
                              ];
                            });
                            isMounted = true;
                          }
                          return SliverToBoxAdapter(
                            child: SpacingColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              onlyPading: true,
                              horizontalPadding: 16,
                              children: [
                                StudentDepartmentHeader(
                                    unitName: widget.unitName,
                                    studentId: widget.studentId,
                                    studentName: widget.studentName),
                                const SizedBox(
                                  height: 12,
                                ),
                                const ItemDivider(),
                                const SizedBox(
                                  height: 12,
                                ),
                                buildSearchFilterSection(
                                    verifiedCount: state
                                        .listCasesModel!.listCases!
                                        .where((e) =>
                                            e.verificationStatus == 'VERIFIED')
                                        .toList()
                                        .length,
                                    unverifiedCount: state
                                        .listCasesModel!.listCases!
                                        .where((e) =>
                                            e.verificationStatus == 'INPROCESS')
                                        .toList()
                                        .length),
                                if (s.isEmpty) ...[
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  const EmptyData(
                                    subtitle: 'Please add case data first!',
                                    title: 'Data Still Empty',
                                  ),
                                ],
                                if (s.isNotEmpty)
                                  ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        TestGradeScoreCard(
                                      id: s[index].caseId!,
                                      studentId: widget.studentId,
                                      caseName: s[index].caseName!,
                                      caseType: s[index].caseType!,
                                      isVerified: s[index].verificationStatus ==
                                          'VERIFIED',
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemCount: s.length,
                                  ),
                                const SizedBox(
                                  height: 48,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SliverFillRemaining(child: CustomLoading());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        return BlocBuilder<CompetenceCubit, CompetenceState>(
          builder: (context, state) {
            return Column(
              children: [
                SearchField(
                  text: '',
                  hint: 'Search Case',
                  onChanged: (value) {
                    final data = state.listCasesModel!.listCases!
                        .where((element) => element.caseName!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    if (value.isEmpty) {
                      listData.value.clear();
                      listData.value = [...state.listCasesModel!.listCases!];
                    } else {
                      listData.value = [...data];
                    }
                  },
                ),
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
                                case 1:
                                  final data = state.listCasesModel!.listCases!
                                      .where((element) =>
                                          element.verificationStatus!
                                              .toUpperCase() ==
                                          'VERIFIED')
                                      .toList();
                                  listData.value = [...data];
                                  break;
                                case 2:
                                  final data = state.listCasesModel!.listCases!
                                      .where((element) =>
                                          element.verificationStatus!
                                              .toUpperCase() ==
                                          'Inprocess'.toUpperCase())
                                      .toList();
                                  listData.value = [...data];
                                  break;
                                case 0:
                                  listData.value.clear();
                                  listData.value = [
                                    ...state.listCasesModel!.listCases!
                                  ];
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

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.caseName,
    required this.caseType,
    required this.isVerified,
    required this.id,
    required this.studentId,
  });

  final String caseName;
  final String id;
  final String studentId;
  final String caseType;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
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
            ]),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      caseType,
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      const ChipVerified(),
                    ],
                    if (!isVerified) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifyCaseDialog(
                                    id: id,
                                    studentId: studentId,
                                  )).then((value) {}),
                          child: const Text('Verify Case'),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
