import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/supervisor_cubit2/supervisors_cubit2.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'widgets/student_unit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListStudentDepartmentPage extends StatefulWidget {
  const SupervisorListStudentDepartmentPage({super.key});

  @override
  State<SupervisorListStudentDepartmentPage> createState() =>
      _SupervisorListStudentDepartmentPageState();
}

class _SupervisorListStudentDepartmentPageState
    extends State<SupervisorListStudentDepartmentPage> {
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    page = 1;
    Future.microtask(() => BlocProvider.of<SupervisorCubit2>(context)
        .getAllStudentDepartment(page: page));
  }

  void _onScroll() {
    final state = context.read<SupervisorCubit2>().state.state;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    BlocProvider.of<SupervisorCubit2>(context).getAllStudentDepartment(
      query: query,
      page: page + 1,
      onScroll: true,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Score'),
        actions: [
          ValueListenableBuilder(
            valueListenable: isSearchExpand,
            builder: (context, value, child) {
              return Stack(
                children: [
                  if (value)
                    Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        )),
                  IconButton(
                    onPressed: () {
                      isSearchExpand.value = !value;
                     
                      if (query != null && query!.isNotEmpty) {
                        query = null;
                        context
                            .read<SupervisorCubit2>()
                            .getAllStudentDepartment(
                              page: page,
                              query: query,
                            );
                      }
                    },
                    icon: const Icon(CupertinoIcons.search),
                  ),
                ],
              );
            },
          ),
        ],
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SupervisorCubit2>(context)
                  .getAllStudentDepartment(page: page, query: query),
            ]);
          },
          child: BlocSelector<SupervisorCubit2, SupervisorState2,
              (List<StudentDepartmentModel>?, RequestState)>(
            selector: (state) => (state.listData, state.state),
            builder: (context, state) {
              final data = state.$1;

              if (data == null || state.$2 == RequestState.loading) {
                return const CustomLoading();
              }
              return ValueListenableBuilder(
                  valueListenable: isSearchExpand,
                  builder: (context, status, _) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Builder(builder: (context) {
                              if (data.isEmpty) {
                                return const EmptyData(
                                    title: 'No Students',
                                    subtitle: 'student not found');
                              }
                              return CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  if (status)
                                    const SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 64,
                                      ),
                                    ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 20,
                                    ),
                                  ),
                                  SliverList.separated(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return StudentDepartmentCard(
                                        data: data[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 12,
                                      );
                                    },
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                        if (status)
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: scaffoldBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          color: Colors.black12,
                                          blurRadius: 12,
                                          spreadRadius: 4)
                                    ]),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: SearchField(
                                        onClear: () {
                                          query = null;
                                          context
                                              .read<SupervisorCubit2>()
                                              .getAllStudentDepartment(
                                                page: page,
                                                query: query,
                                              );
                                        },
                                        onChanged: (value) {
                                          query = value;
                                          context
                                              .read<SupervisorCubit2>()
                                              .getAllStudentDepartment(
                                                page: page,
                                                query: query,
                                              );
                                        },
                                        text: '',
                                        hint: 'Search for student',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
