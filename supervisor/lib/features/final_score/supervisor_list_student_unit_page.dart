import 'package:core/context/navigation_extension.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/supervisor_cubit2/supervisors_cubit2.dart';
import 'package:main/widgets/custom_loading.dart';
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
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 12,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
