import 'package:core/context/navigation_extension.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inputs/search_field.dart';

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
  String? filterUnitId;
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
    BlocProvider.of<SglCstCubit>(context).getListCstStudents(
        unitId: filterUnitId, query: query, page: page + 1, onScroll: true);
    page++;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  initUnit: filterUnitId,
                  onTap: (f) {
                    filterUnitId = f;
                    page = 1;
                    BlocProvider.of<SglCstCubit>(context).getListCstStudents(
                        unitId: f, query: query, page: page);
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
                unitId: filterUnitId, page: page, query: query),
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
                              unitId: filterUnitId, page: page, query: query);
                        },
                        onChanged: (value) {
                          query = value;
                          context.read<SglCstCubit>().getListCstStudents(
                              unitId: filterUnitId, page: page, query: query);
                        },
                        text: '',
                        hint: 'Search for student',
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 12,
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
  }
}
