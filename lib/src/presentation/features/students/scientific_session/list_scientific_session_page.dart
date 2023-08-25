import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/add_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/widgets/scientific_session_card.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListScientificSessionPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const StudentListScientificSessionPage(
      {super.key, required this.activeUnitModel});

  @override
  State<StudentListScientificSessionPage> createState() =>
      _StudentListScientificSessionPageState();
}

class _StudentListScientificSessionPageState
    extends State<StudentListScientificSessionPage> {
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);
    BlocProvider.of<StudentCubit>(context)
      ..getStudentScientificSessionOfActiveUnit();
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
        title: Text("Scientific Session"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.navigateTo(
            AddScientificSessionPage(activeUnitModel: widget.activeUnitModel)),
        child: Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state.scientificSessionResponse != null) {
                return SpacingColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  onlyPading: true,
                  horizontalPadding: 16,
                  children: [
                    UnitHeader(unitName: widget.activeUnitModel.unitName!),
                    SizedBox(
                      height: 12,
                    ),
                    SectionDivider(),
                    Builder(
                      builder: (context) {
                        if (state.scientificSessionResponse != null) {
                          final data = state.scientificSessionResponse!
                              .listScientificSessions!;
                          if (data.isEmpty) {
                            return EmptyData(
                              subtitle:
                                  'Please upload scientific session data first!',
                              title: 'Data Still Empty',
                            );
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              buildSearchFilterSection(
                                verifiedCount: state
                                    .scientificSessionResponse!.verifiedCounts!,
                                unverifiedCount: state
                                    .scientificSessionResponse!
                                    .unverifiedCounts!,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    StudentScientificSessionCard(
                                  model: state.scientificSessionResponse!
                                      .listScientificSessions![index],
                                ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12),
                                itemCount: data.length,
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
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