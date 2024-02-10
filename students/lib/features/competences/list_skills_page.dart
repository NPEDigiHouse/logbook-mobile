import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/competences/list_skills_model.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:students/features/competences/widgets/update_competence_dialog.dart';

import 'widgets/add_competence_dialog.dart';

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
      BlocProvider.of<CompetenceCubit>(context).getListSkills();
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
        title: const Text("List Skills"),
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
                BlocProvider.of<CompetenceCubit>(context).getListSkills(),
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
                              if (state.isSkillSuccessAdded) {
                                isMounted = false;
                              }
                              if (state.isDeleteSkillSuccess) {
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
                                    listData.notifyListeners();
                                  });
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state.listSkillsModel != null) {
                                return SingleChildScrollView(
                                  child: SpacingColumn(
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
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Builder(builder: (context) {
                                        if (s.isEmpty) {
                                          return const EmptyData(
                                            subtitle:
                                                'Please add skill data first!',
                                            title: 'Data Still Empty',
                                          );
                                        }
                                        return ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) =>
                                              TestGradeScoreCard(
                                            skillId: s[index].skillTypeId ?? -1,
                                            unitId: widget.unitId,
                                            onDelete: () {
                                              isMounted = false;
                                              BlocProvider.of<CompetenceCubit>(
                                                      context)
                                                  .deleteSkillById(
                                                      id: s[index].skillId!);
                                              BlocProvider.of<CompetenceCubit>(
                                                      context)
                                                  .getListSkills();

                                              Navigator.pop(context);
                                            },
                                            id: s[index].skillId ?? '',
                                            createdAt: DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    s[index].createdAt ?? 0),
                                            caseName: s[index].skillName!,
                                            caseType: s[index].skillType!,
                                            isVerified:
                                                s[index].verificationStatus ==
                                                    'VERIFIED',
                                            supervisorName:
                                                s[index].supervisorName ?? '',
                                          ),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 12),
                                          itemCount: s.length,
                                        );
                                      }),
                                      const SizedBox(
                                        height: 16,
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
    required this.createdAt,
    required this.supervisorName,
    required this.onDelete,
    required this.id,
    required this.skillId,
    required this.unitId,
  });

  final String caseName;
  final String caseType;
  final DateTime createdAt;
  final String supervisorName;
  final bool isVerified;
  final VoidCallback onDelete;
  final String id;
  final int skillId;
  final String unitId;

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
                      style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: primaryColor),
                    ),
                    Text(
                      caseType,
                      style: textTheme.bodySmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Utils.datetimeToString(createdAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: primaryTextColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    ChipVerified(
                      isVerified: isVerified,
                    ),
                  ],
                ),
              ),
              if (!isVerified)
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  onSelected: (value) {
                    if (value == 'Edit') {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => EditCompetenceDialog(
                          type: CompetenceType.skillType,
                          unitId: unitId,
                          caseId: skillId,
                          caseName: caseName,
                          id: id,
                          caseType: caseType,
                          supervisorName: supervisorName,
                        ),
                      ).then((value) {});
                    }
                    if (value == 'Delete') {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => VerifyDialog(
                          onTap: onDelete,
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
