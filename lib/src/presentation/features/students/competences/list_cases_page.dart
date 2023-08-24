import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/features/students/competences/widgets/add_competence_dialog.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListCasesPage extends StatefulWidget {
  final String unitId;
  const ListCasesPage({super.key, required this.unitId});

  @override
  State<ListCasesPage> createState() => _ListCasesPageState();
}

class _ListCasesPageState extends State<ListCasesPage> {
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
      BlocProvider.of<CompetenceCubit>(context)..getListCases();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("List Cases"),
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
        child: Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SpacingColumn(
            onlyPading: true,
            horizontalPadding: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UnitHeader(),
                  SizedBox(
                    height: 16,
                  ),
                  buildSearchFilterSection(),
                  SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<CompetenceCubit, CompetenceState>(
                    builder: (context, state) {
                      if (state.listCasesModel != null) {
                        final data = state.listCasesModel!.listCases!;
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => TestGradeScoreCard(
                            caseName: data[index].caseName!,
                            caseType: data[index].caseType!,
                            isVerified:
                                data[index].verificationStatus == 'VERIFIED',
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemCount: data.length,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
  });

  final String caseName;
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
              Column(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
