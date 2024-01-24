import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:data/models/units/unit_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

import 'widgets/cst_card.dart';
import 'widgets/select_department_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListCstPage extends StatefulWidget {
  final bool isCeu;
  final String userId;
  const SupervisorListCstPage(
      {super.key, required this.isCeu, required this.userId});

  @override
  State<SupervisorListCstPage> createState() => _SupervisorListCstPageState();
}

class _SupervisorListCstPageState extends State<SupervisorListCstPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: _SupervisorListCstView(isCeu: widget.isCeu, userId: widget.userId),
    );
  }
}

class _SupervisorListCstView extends StatefulWidget {
  final bool isCeu;
  final String userId;
  const _SupervisorListCstView({required this.isCeu, required this.userId});

  @override
  State<_SupervisorListCstView> createState() => __SupervisorListCstViewState();
}

class __SupervisorListCstViewState extends State<_SupervisorListCstView> {
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    page = 1;
    Future.microtask(() =>
        BlocProvider.of<SglCstCubit>(context).getListCstStudents(page: 1));
  }

  void _onScroll() {
    final state = context.read<SglCstCubit>().state.cstState;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final d = context.read<FilterNotifier>();
    BlocProvider.of<SglCstCubit>(context).getListCstStudents(
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
    return Consumer<FilterNotifier>(builder: (context, ntf, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Clinical Skill Training'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  builder: (ctx) => SelectDepartmentSheet(
                    initUnit: DepartmentModel(id: '', name: ''),
                    filterType: FilterType.unverified,
                    onTap: (f, u) {
                      // filterUnitId = f;
                      context.read<FilterNotifier>().setFilterType = f;
                      context.read<FilterNotifier>().setDepartmentModel = u;
                      page = 1;
                      BlocProvider.of<SglCstCubit>(context).getListCstStudents(
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
        body: RefreshIndicator(
          onRefresh: () async {
            page = 1;
            await Future.wait([
              BlocProvider.of<SglCstCubit>(context).getListCstStudents(
                  unitId: ntf.unit?.id, page: page, query: query),
            ]);
          },
          child: SafeArea(
            child: BlocSelector<SglCstCubit, SglCstState,
                (List<SglCstOnList>?, RequestState)>(
              selector: (state) => (state.cstStudents, state.cstState),
              builder: (context, state) {
                final data = state.$1;

                if (data == null || state.$2 == RequestState.loading) {
                  return const CustomLoading();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomScrollView(
                    controller: _scrollController,
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
                            context.read<SglCstCubit>().getListCstStudents(
                                unitId: ntf.unit?.id,
                                page: page,
                                query: query,
                                type: ntf.filterType);
                          },
                          onChanged: (value) {
                            query = value;
                            context.read<SglCstCubit>().getListCstStudents(
                                unitId: ntf.unit?.id,
                                page: page,
                                query: query,
                                type: ntf.filterType);
                          },
                          text: '',
                          hint: 'Search for student',
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
                                      BlocProvider.of<SglCstCubit>(context)
                                          .getListCstStudents(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query);
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
                                      BlocProvider.of<SglCstCubit>(context)
                                          .getListCstStudents(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverList.separated(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return CstOnListCard(
                            sglCst: data[index],
                            isCeu: widget.isCeu,
                            userId: widget.userId,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 12,
                        ),
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
}
