import 'package:core/context/navigation_extension.dart';
import 'package:data/models/scientific_session/scientific_session_on_list_model.dart';
import 'package:main/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'scientific_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListScientificSessionPage extends StatefulWidget {
  const SupervisorListScientificSessionPage({super.key});

  @override
  State<SupervisorListScientificSessionPage> createState() =>
      _SupervisorListScientificSessionPageState();
}

class _SupervisorListScientificSessionPageState
    extends State<SupervisorListScientificSessionPage> {
  ValueNotifier<List<ScientificSessionOnListModel>> listStudent =
      ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
      .getScientificSessionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Session'),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          isMounted = false;
          await Future.wait([
            BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                .getScientificSessionList(),
          ]);
        },
        child: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocBuilder<ScientificSessionSupervisorCubit,
                    ScientificSessionSupervisorState>(
                  builder: (context, state) {
                    if (state.listData == null) {
                      return const CustomLoading();
                    }
                    if (!isMounted) {
                      Future.microtask(() {
                        listStudent.value = [...state.listData!];
                      });
                      isMounted = true;
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
                              onChanged: (value) {
                                final data = state.listData!
                                    .where((element) => element.studentName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                if (value.isEmpty) {
                                  listStudent.value.clear();
                                  listStudent.value = [...state.listData!];
                                } else {
                                  listStudent.value = [...data];
                                }
                              },
                              text: 'Search',
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverList.separated(
                            itemCount: s.length,
                            itemBuilder: (context, index) {
                              return ScientificSessionCard(
                                scientificSession: s[index],
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
                );
              }),
        ),
      ),
    );
  }
}
