import 'package:common/no_internet/check_internet_onetime.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/competences/list_cases_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/widgets/chip_verified.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'widgets/add_competence_dialog.dart';

class ListCasesPage extends StatefulWidget {
  final String unitName;
  // final int countCheckIn;

  final String unitId;
  const ListCasesPage({
    super.key,
    required this.unitName,
    required this.unitId,
    // required this.countCheckIn,
  });

  @override
  State<ListCasesPage> createState() => _ListCasesPageState();
}

class _ListCasesPageState extends State<ListCasesPage> {
  ValueNotifier<List<CaseModel>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    Future.microtask(() {
      BlocProvider.of<CompetenceCubit>(context).getListCases();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Cases"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            barrierLabel: '',
            barrierDismissible: false,
            builder: (_) => AddCompetenceDialog(
                  type: CompetenceType.caseType,
                  unitId: widget.unitId,
                )).then((value) {}),
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
                BlocProvider.of<CompetenceCubit>(context).getListCases(),
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
                          child: BlocConsumer<CompetenceCubit, CompetenceState>(
                            listener: (context, state) {
                              if (state.isCaseSuccessAdded) {
                                isMounted = false;
                              }
                              if (state.listCasesModel != null &&
                                  state.caseState == RequestState.data) {
                                if (!isMounted) {
                                  Future.microtask(() {
                                    listData.value = [
                                      ...state.listCasesModel!.listCases!
                                    ];
                                    isMounted = true;
                                  });
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state.listCasesModel != null) {
                                final data = state.listCasesModel!.listCases!;
                                if (data.isEmpty) {
                                  return const EmptyData(
                                    subtitle: 'Please add case data first!',
                                    title: 'Data Still Empty',
                                  );
                                }
                                return SingleChildScrollView(
                                  child: SpacingColumn(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    onlyPading: true,
                                    horizontalPadding: 16,
                                    children: [
                                      DepartmentHeader(
                                          unitName: widget.unitName),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      buildSearchFilterSection(
                                        verifiedCount: state
                                            .listCasesModel!.listCases!
                                            .where((element) =>
                                                element.verificationStatus ==
                                                'VERIFIED')
                                            .length,
                                        unverifiedCount: state
                                            .listCasesModel!.listCases!
                                            .where((element) =>
                                                element.verificationStatus !=
                                                'VERIFIED')
                                            .length,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            TestGradeScoreCard(
                                          onDelete: () {
                                            isMounted = false;
                                            BlocProvider.of<CompetenceCubit>(
                                                    context)
                                                .deleteCaseById(
                                                    id: s[index].caseId!);
                                            BlocProvider.of<CompetenceCubit>(
                                                    context)
                                                .getListCases();
                                            Navigator.pop(context);
                                          },
                                          caseName: s[index].caseName!,
                                          caseType: s[index].caseType!,
                                          supervisorName:
                                              s[index].supervisorName ?? '',
                                          isVerified:
                                              s[index].verificationStatus ==
                                                  'VERIFIED',
                                        ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 12),
                                        itemCount: s.length,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const CustomLoading();
                              }
                            },
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
        return BlocBuilder<CompetenceCubit, CompetenceState>(
          builder: (context, state) {
            return Column(
              children: [
                SearchField(
                  text: '',
                  hint: 'Search Cases',
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
                                case 0:
                                  listData.value = [
                                    ...state.listCasesModel!.listCases!
                                  ];
                                  break;
                                case 1:
                                  listData.value = [
                                    ...state.listCasesModel!.listCases!
                                        .where((element) =>
                                            element.verificationStatus ==
                                            'VERIFIED')
                                        .toList()
                                  ];
                                  break;
                                case 2:
                                  listData.value = [
                                    ...state.listCasesModel!.listCases!
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

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.supervisorName,
    required this.caseName,
    required this.caseType,
    required this.isVerified,
    required this.onDelete,
  });

  final String caseName;
  final String caseType;
  final VoidCallback onDelete;
  final String supervisorName;
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
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Supervisor:\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: supervisorName,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      caseName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold, height: 1.1),
                    ),
                    const SizedBox(
                      height: 2,
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
                    ]
                  ],
                ),
              ),
              if (!isVerified)
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierLabel: '',
                      barrierDismissible: false,
                      builder: (_) => VerifyDialog(
                        onTap: onDelete,
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Icon(
                        Icons.delete_rounded,
                        color: errorColor,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
