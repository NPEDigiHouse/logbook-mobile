import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/competences/student_competence_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/features/sgl_cst/widgets/select_department_sheet.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

import 'list_cases_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListStudentCasesPage extends StatelessWidget {
  const ListStudentCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: const _ListStudentCasesView(),
    );
  }
}

class _ListStudentCasesView extends StatefulWidget {
  const _ListStudentCasesView();

  @override
  State<_ListStudentCasesView> createState() => _ListStudentCasesPageView();
}

class _ListStudentCasesPageView extends State<_ListStudentCasesView> {
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    page = 1;
    BlocProvider.of<CompetenceCubit>(context).getCaseStudents(
      page: page,
    );
  }

  void _onScroll() {
    final state = context.read<CompetenceCubit>().state.fetchState;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final d = context.read<FilterNotifier>();
    BlocProvider.of<CompetenceCubit>(context).getCaseStudents(
      unitId: d.unit?.id,
      query: query,
      page: page + 1,
      onScroll: true,
      type: d.filterType,
    );
    page++;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterNotifier>(builder: (context, ntf, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Submitted Case'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  builder: (ctx) => SelectDepartmentSheet(
                    initUnit: ntf.unit,
                    filterType: ntf.filterType,
                    onTap: (f, u) {
                      // filterUnitId = f;
                      context.read<FilterNotifier>().setFilterType = f;
                      context.read<FilterNotifier>().setDepartmentModel = u;
                      page = 1;
                      BlocProvider.of<CompetenceCubit>(context).getCaseStudents(
                          unitId: u?.id, query: query, page: page, type: f);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.line_horizontal_3_decrease,
              ),
            )
          ],
        ).variant(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              page = 1;
              await Future.wait([
                BlocProvider.of<CompetenceCubit>(context).getCaseStudents(
                    unitId: ntf.unit?.id, page: page, query: query),
              ]);
            },
            child: BlocSelector<CompetenceCubit, CompetenceState,
                (List<StudentCompetenceModel>?, RequestState)>(
              selector: (state) => (state.caseListStudent, state.fetchState),
              builder: (context, state) {
                final data = state.$1;

                if (data == null || state.$2 == RequestState.loading) {
                  return const CustomLoading();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 16,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SearchField(
                          onClear: () {
                            query = null;
                            context.read<CompetenceCubit>().getCaseStudents(
                                unitId: ntf.unit?.id,
                                page: page,
                                query: query,
                                type: ntf.filterType);
                          },
                          onChanged: (value) {
                            query = value;
                            context.read<CompetenceCubit>().getCaseStudents(
                                unitId: ntf.unit?.id,
                                page: page,
                                query: query,
                                type: ntf.filterType);
                          },
                          text: '',
                          hint: 'Search student',
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 8,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                if (ntf.filterType != FilterType.all)
                                  Chip(
                                    backgroundColor:
                                        primaryColor.withOpacity(.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    side: BorderSide(
                                        color: secondaryColor.withOpacity(.5)),
                                    label: Text(
                                        ntf.filterType.name.toCapitalize()),
                                    labelStyle: textTheme.bodyMedium
                                        ?.copyWith(color: primaryColor),
                                    deleteIcon: const Icon(
                                      Icons.close_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                    onDeleted: () {
                                      context
                                          .read<FilterNotifier>()
                                          .setFilterType = FilterType.all;
                                      BlocProvider.of<CompetenceCubit>(context)
                                          .getCaseStudents(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query,
                                              type: ntf.filterType);
                                    },
                                  ),
                                const SizedBox(
                                  width: 8,
                                ),
                                if (ntf.unit != null)
                                  Chip(
                                    backgroundColor:
                                        primaryColor.withOpacity(.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    side: BorderSide(
                                        color: secondaryColor.withOpacity(.5)),
                                    label: Text(
                                        '${ntf.unit?.name.toCapitalize()}'),
                                    labelStyle: textTheme.bodyMedium
                                        ?.copyWith(color: primaryColor),
                                    deleteIcon: const Icon(
                                      Icons.close_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                    onDeleted: () {
                                      context
                                          .read<FilterNotifier>()
                                          .setDepartmentModel = null;
                                      BlocProvider.of<CompetenceCubit>(context)
                                          .getCaseStudents(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query,
                                              type: ntf.filterType);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (data.isNotEmpty)
                        SliverList.separated(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return _buildStudentCard(context, data[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 12,
                            );
                          },
                        )
                      else
                        const SliverToBoxAdapter(
                          child: EmptyData(
                              title: 'No Cases', subtitle: 'data not found'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStudentCard(
      BuildContext context, StudentCompetenceModel student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(
        SupervisorListCasesPage(
          unitName: student.activeDepartmentName ?? '',
          studentId: student.studentId!,
          studentName: student.studentName ?? '...',
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 68,
              height: 68,
              color: primaryColor.withOpacity(.1),
              child: const Center(
                child: Icon(
                  Icons.cases_rounded,
                  color: primaryColor,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Case',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: onFormDisableColor,
                    height: 1.2,
                  ),
                ),
                Text(
                  Utils.datetimeToString(student.latest!,
                      format: 'EEE, dd MMM'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(
                      (student.studentName ?? '').toCapitalize(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        height: 1,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
