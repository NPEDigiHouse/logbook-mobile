import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/widgets/verify_case_dialog.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListCasesPage extends StatefulWidget {
  final String studentId;
  final String unitName;
  const SupervisorListCasesPage(
      {super.key, required this.unitName, required this.studentId});

  @override
  State<SupervisorListCasesPage> createState() =>
      _SupervisorListCasesPageState();
}

class _SupervisorListCasesPageState extends State<SupervisorListCasesPage> {
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
        ..getCasesByStudentId(
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
    return BlocBuilder<CompetenceCubit, CompetenceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("List Cases"),
          ),
          floatingActionButton: SizedBox(
            width: AppSize.getAppWidth(context) - 32,
            child: state.listCasesModel != null &&
                    state.listCasesModel!.listCases!.indexWhere((element) =>
                            element.verificationStatus == 'VERIFIED') ==
                        -1
                ? FilledButton(
                    onPressed: () {
                      BlocProvider.of<CompetenceCubit>(context)
                        ..verifyAllCaseOfStudent(studentId: widget.studentId);
                    },
                    child: Text('Verify All Case'),
                  )
                : null,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  BlocProvider.of<CompetenceCubit>(context).getCasesByStudentId(
                    studentId: widget.studentId,
                  ),
                ]);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    sliver: Builder(
                      builder: (context) {
                        if (state.listCasesModel != null) {
                          final data = state.listCasesModel!.listCases!;
                          if (data.isEmpty) {
                            return SliverFillRemaining(
                              child: EmptyData(
                                subtitle: 'Please add case data first!',
                                title: 'Data Still Empty',
                              ),
                            );
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
                                ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      TestGradeScoreCard(
                                    id: data[index].caseId!,
                                    studentId: widget.studentId,
                                    caseName: data[index].caseName!,
                                    caseType: data[index].caseType!,
                                    isVerified:
                                        data[index].verificationStatus ==
                                            'VERIFIED',
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12),
                                  itemCount: data.length,
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
        return Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _query,
              builder: (context, query, child) {
                return SearchField(
                  text: query,
                  onChanged: (value) => _query.value = value,
                );
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
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: selected ? primaryColor : primaryTextColor,
                        ),
                        side: BorderSide(
                          color: selected ? Colors.transparent : borderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        checkmarkColor: primaryColor,
                        selectedColor: primaryColor.withOpacity(.2),
                        selected: selected,
                        onSelected: (_) =>
                            _selectedMenu.value = _menuList[index],
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
                          caseName,
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
                      caseType,
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
                              builder: (_) => VerifyCaseDialog(
                                    id: id,
                                    studentId: studentId,
                                  )).then((value) {}),
                          child: Text('Verify Case'),
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
