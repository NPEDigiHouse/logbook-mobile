import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/features/common/no_internet/check_internet_onetime.dart';
import 'package:elogbook/src/presentation/features/students/competences/widgets/add_competence_dialog.dart';
import 'package:elogbook/src/presentation/widgets/chip_verified.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListSkillsPage extends StatefulWidget {
  final String unitName;
  final String unitId;
  // final int countCheckIn;
  const ListSkillsPage({
    super.key,
    required this.unitName,
    required this.unitId,
    // required this.countCheckIn,
  });

  @override
  State<ListSkillsPage> createState() => _ListSkillsPageState();
}

class _ListSkillsPageState extends State<ListSkillsPage> {
  ValueNotifier<List<SkillModel>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);

    super.initState();
    Future.microtask(() {
      BlocProvider.of<CompetenceCubit>(context)..getListSkills();
    });
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
        title: Text("List Skills"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            barrierLabel: '',
            barrierDismissible: false,
            builder: (_) => AddCompetenceDialog(
                  type: CompetenceType.skillType,
                  unitId: widget.unitId,
                )).then((value) {}),
        child: Icon(
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
                        padding: EdgeInsets.symmetric(vertical: 16),
                        sliver: SliverFillRemaining(
                          child: BlocConsumer<CompetenceCubit, CompetenceState>(
                            listener: (context, state) {
                              if (state.isSkillSuccessAdded) {
                                isMounted = false;
                              }
                              if (state.listSkillsModel != null &&
                                  state.skillState == RequestState.data) {
                                if (!isMounted) {
                                  Future.microtask(() {
                                    listData.value = [
                                      ...state.listSkillsModel!.listSkills!
                                    ];
                                    isMounted = true;
                                  });
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state.listSkillsModel != null) {
                                final data = state.listSkillsModel!.listSkills!;
                                if (data.isEmpty) {
                                  return EmptyData(
                                    subtitle: 'Please add skill data first!',
                                    title: 'Data Still Empty',
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
                                          unitName: widget.unitName),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      buildSearchFilterSection(
                                        verifiedCount: state
                                            .listSkillsModel!.listSkills!
                                            .where((element) =>
                                                element.verificationStatus ==
                                                'VERIFIED')
                                            .length,
                                        unverifiedCount: state
                                            .listSkillsModel!.listSkills!
                                            .where((element) =>
                                                element.verificationStatus !=
                                                'VERIFIED')
                                            .length,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            TestGradeScoreCard(
                                          onDelete: () {
                                            isMounted = false;
                                            BlocProvider.of<CompetenceCubit>(
                                                context)
                                              ..deleteSkillById(
                                                  id: s[index].skillId!);
                                            BlocProvider.of<CompetenceCubit>(
                                                context)
                                              ..getListSkills();

                                            Navigator.pop(context);
                                          },
                                          caseName: s[index].skillName!,
                                          caseType: s[index].skillType!,
                                          isVerified:
                                              s[index].verificationStatus ==
                                                  'VERIFIED',
                                          supervisorName:
                                              s[index].supervisorName ?? '',
                                        ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 12),
                                        itemCount: s.length,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return CustomLoading();
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
    final _menuList = [
      'All',
      '${verifiedCount} Verified',
      '${unverifiedCount} Unverified',
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
                  hint: 'Search Skill',
                  onChanged: (value) {
                    final data = state.listSkillsModel!.listSkills!
                        .where((element) => element.skillName!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    if (value.isEmpty) {
                      listData.value.clear();
                      listData.value = [...state.listSkillsModel!.listSkills!];
                    } else {
                      listData.value = [...data];
                    }
                  },
                ),
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _menuList.length,
                    itemBuilder: (context, index) {
                      return ValueListenableBuilder(
                        valueListenable: _selectedMenu,
                        builder: (context, value, child) {
                          final selected = value == _menuList[index];

                          return RawChip(
                            pressElevation: 0,
                            clipBehavior: Clip.antiAlias,
                            label: Text(_menuList[index]),
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
                              _selectedMenu.value = _menuList[index];
                              switch (index) {
                                case 0:
                                  listData.value = [
                                    ...state.listSkillsModel!.listSkills!
                                  ];
                                  break;
                                case 1:
                                  listData.value = [
                                    ...state.listSkillsModel!.listSkills!
                                        .where((element) =>
                                            element.verificationStatus ==
                                            'VERIFIED')
                                        .toList()
                                  ];
                                  break;
                                case 2:
                                  listData.value = [
                                    ...state.listSkillsModel!.listSkills!
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
    required this.caseName,
    required this.caseType,
    required this.isVerified,
    required this.supervisorName,
    required this.onDelete,
  });

  final String caseName;
  final String caseType;
  final String supervisorName;
  final bool isVerified;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                  blurRadius: 6,
                  color: Color(0xFFD4D4D4).withOpacity(.25)),
              BoxShadow(
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                  blurRadius: 24,
                  color: Color(0xFFD4D4D4).withOpacity(.25)),
            ]),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(
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
                          TextSpan(
                            text: 'Supervisor:\t',
                            style: const TextStyle(
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
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      caseType,
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(
                        height: 4,
                      ),
                      ChipVerified(),
                    ]
                  ],
                ),
              ),
              if(!isVerified)
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
                child: SizedBox(
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
