import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_first_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/clinical_record_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListClinicalRecordPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const ListClinicalRecordPage({super.key, required this.activeUnitModel});

  @override
  State<ListClinicalRecordPage> createState() => _ListClinicalRecordPageState();
}

class _ListClinicalRecordPageState extends State<ListClinicalRecordPage> {
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);
    BlocProvider.of<StudentCubit>(context)
      ..getStudentClinicalRecordOfActiveUnit();
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
        title: Text("Clinical Records"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.navigateTo(CreateClinicalRecordFirstPage(
            activeUnitModel: widget.activeUnitModel)),
        child: Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state.clinicalRecordResponse != null) {
                return SpacingColumn(
                  onlyPading: true,
                  horizontalPadding: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UnitHeader(unitName: widget.activeUnitModel.unitName!),
                        SizedBox(
                          height: 16,
                        ),
                        buildSearchFilterSection(
                          verifiedCount:
                              state.clinicalRecordResponse!.verifiedCounts!,
                          unverifiedCount:
                              state.clinicalRecordResponse!.unverifiedCounts!,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Builder(
                          builder: (context) {
                            if (state.clinicalRecordResponse != null) {
                              final data = state
                                  .clinicalRecordResponse!.listClinicalRecords!;
                              return ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    ClinicalRecordCard(
                                  model: state.clinicalRecordResponse!
                                      .listClinicalRecords![index],
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
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
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
