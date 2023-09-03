import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_on_list_model.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/scientific_session_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
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
      ..getScientificSessionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Session'),
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
                      return CustomLoading();
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
                          SliverToBoxAdapter(
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
                          SliverToBoxAdapter(
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
                              return SizedBox(
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
