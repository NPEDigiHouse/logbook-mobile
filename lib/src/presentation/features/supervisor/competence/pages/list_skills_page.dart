import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/widgets/verify_skill_dialog.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSkillsPage extends StatefulWidget {
  final String studentId;
  final String unitName;
  const SupervisorListSkillsPage(
      {super.key, required this.unitName, required this.studentId});

  @override
  State<SupervisorListSkillsPage> createState() =>
      _SupervisorListSkillsPageState();
}

class _SupervisorListSkillsPageState extends State<SupervisorListSkillsPage> {
  ValueNotifier<List<SkillModel>> listData = ValueNotifier([]);
  bool isMounted = false;
  late final List<String> _menuList;

  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _menuList = [
      'All',
      'Verified',
      'Unverified',
    ];

    Future.microtask(() {
      BlocProvider.of<CompetenceCubit>(context)
        ..getSkillsByStudentId(
          studentId: widget.studentId,
        );
    });

    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier(_menuList[0]);
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
        if (state.isSkillSuccessVerify || state.isAllSkillsSuccessVerify) {
          BlocProvider.of<CompetenceCubit>(context)
            ..getCasesByStudentId(
              studentId: widget.studentId,
            );
          isMounted = false;
        }
        if (state.listSkillsModel != null &&
            state.requestState == RequestState.data &&
            !isMounted) {
          _menuList[1] =
              '${state.listSkillsModel!.listSkills!.where((e) => e.verificationStatus == 'VERIFIED').toList().length} ${_menuList[1]}';
          _menuList[2] =
              '${state.listSkillsModel!.listSkills!.where((e) => e.verificationStatus == 'INPROCESS').toList().length} ${_menuList[2]}';
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("List Skills"),
          ),
          floatingActionButton: SizedBox(
            width: AppSize.getAppWidth(context) - 32,
            child: state.listSkillsModel != null &&
                    state.listSkillsModel!.listSkills!.indexWhere((element) =>
                            element.verificationStatus == 'INPROCESS') !=
                        -1
                ? FilledButton(
                    onPressed: () {
                      BlocProvider.of<CompetenceCubit>(context)
                        ..verifyAllCaseOfStudent(studentId: widget.studentId);
                    },
                    child: Text('Verify All Skils'),
                  )
                : null,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<CompetenceCubit>(context).getSkillsByStudentId(
                  studentId: widget.studentId,
                ),
              ]);
            },
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    sliver: ValueListenableBuilder(
                      valueListenable: listData,
                      builder: (context, s, _) {
                        if (state.listSkillsModel != null &&
                            state.requestState == RequestState.data) {
                          if (!isMounted) {
                            Future.microtask(() {
                              listData.value = [
                                ...state.listSkillsModel!.listSkills!
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
                                UnitHeader(unitName: widget.unitName),
                                SizedBox(
                                  height: 12,
                                ),
                                buildSearchFilterSection(),
                                SizedBox(
                                  height: 24,
                                ),
                                if (s.isEmpty)
                                  EmptyData(
                                    subtitle: 'Please add skill data first!',
                                    title: 'Data Still Empty',
                                  ),
                                if (s.isNotEmpty)
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        TestGradeScoreCard(
                                      id: s[index].skillId!,
                                      studentId: widget.studentId,
                                      skillName: s[index].skillName!,
                                      skillType: s[index].skillType!,
                                      isVerified: s[index].verificationStatus ==
                                          'VERIFIED',
                                    ),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 12),
                                    itemCount: s.length,
                                  ),
                              ],
                            ),
                          );
                        } else {
                          return SliverFillRemaining(child: CustomLoading());
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

  ValueListenableBuilder<Map<String, String>?> buildSearchFilterSection() {
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
                                case 1:
                                  final data = state
                                      .listSkillsModel!.listSkills!
                                      .where((element) =>
                                          element.verificationStatus!
                                              .toUpperCase() ==
                                          'VERIFIED')
                                      .toList();
                                  listData.value = [...data];
                                  break;
                                case 2:
                                  print('call');
                                  final data = state
                                      .listSkillsModel!.listSkills!
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
                                    ...state.listSkillsModel!.listSkills!
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
    required this.skillName,
    required this.skillType,
    required this.isVerified,
    required this.id,
    required this.studentId,
  });

  final String skillName;
  final String id;
  final String studentId;
  final String skillType;
  final bool isVerified;

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          skillName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isVerified) ...[
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: primaryColor,
                          ),
                        ]
                      ],
                    ),
                    Text(
                      skillType,
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    if (!isVerified) ...[
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifySkillDialog(
                                    id: id,
                                    studentId: studentId,
                                  )).then((value) {}),
                          child: Text('Verify Skill'),
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
