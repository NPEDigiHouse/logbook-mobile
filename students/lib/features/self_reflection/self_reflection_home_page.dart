import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'create_self_reflection_page.dart';
import 'widgets/self_reflection_card.dart';

class StudentSelfReflectionHomePage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final UserCredential credential;

  const StudentSelfReflectionHomePage(
      {super.key,
      required this.activeDepartmentModel,
      required this.credential});

  @override
  State<StudentSelfReflectionHomePage> createState() =>
      _StudentSelfReflectionHomePageState();
}

class _StudentSelfReflectionHomePageState
    extends State<StudentSelfReflectionHomePage> {
  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier('All');
    _dataFilters = ValueNotifier(null);
    BlocProvider.of<StudentCubit>(context).getStudentSelfReflections();
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
        title: const Text("Self Reflections"),
      ),
      floatingActionButton: (widget.credential.student?.examinerDPKId != null)
          ? FloatingActionButton(
              onPressed: () => context.navigateTo(CreateSelfReflectionPage(
                credential: widget.credential,
              )),
              child: const Icon(
                Icons.add_rounded,
              ),
            )
          : null,
      body: SafeArea(
        child: CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<StudentCubit>(context)
                    .getStudentSelfReflections(),
              ]);
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverFillRemaining(
                    child: BlocBuilder<StudentCubit, StudentState>(
                      builder: (context, state) {
                        if (state.selfReflectionResponse != null) {
                          return SingleChildScrollView(
                            child: SpacingColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              onlyPading: true,
                              horizontalPadding: 16,
                              children: [
                                DepartmentHeader(
                                    unitName:
                                        widget.activeDepartmentModel.unitName!),
                                const SizedBox(
                                  height: 12,
                                ),
                                const ItemDivider(),
                                if (widget.credential.student?.examinerDPKId ==
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Please select a supervisor first in the profile menu before creating a self reflection',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: errorColor,
                                      ),
                                    ),
                                  ),
                                Builder(
                                  builder: (context) {
                                    if (state.selfReflectionResponse != null) {
                                      final data = state.selfReflectionResponse!
                                          .listSelfReflections!;
                                      if (data.isEmpty) {
                                        return const EmptyData(
                                          subtitle:
                                              'Please add self reflection first!',
                                          title: 'Data Still Empty',
                                        );
                                      }
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                StudentSelfReflectionCard(
                                              model: state
                                                  .selfReflectionResponse!
                                                  .listSelfReflections![index],
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              child: ItemDivider(),
                                            ),
                                            itemCount: data.length,
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
                        return const CustomLoading();
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                            _selectedMenu.value = menuList[index],
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
