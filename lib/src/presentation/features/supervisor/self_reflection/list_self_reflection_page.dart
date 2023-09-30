import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_model.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSelfReflectionsPage extends StatefulWidget {
  const SupervisorListSelfReflectionsPage({super.key});

  @override
  State<SupervisorListSelfReflectionsPage> createState() =>
      _SupervisorListSelfReflectionsPageState();
}

class _SupervisorListSelfReflectionsPageState
    extends State<SupervisorListSelfReflectionsPage> {
  ValueNotifier<List<SelfReflectionModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<SelfReflectionSupervisorCubit>(context)
          ..getSelfReflections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self Reflection Page'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            isMounted = false;
            await Future.wait([
              BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  .getSelfReflections(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocBuilder<SelfReflectionSupervisorCubit,
                    SelfReflectionSupervisorState>(
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
                    if (state.listData!.isNotEmpty) {
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
                                text: '',
                                hint: 'Search for student',
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 12,
                              ),
                            ),
                            SliverList.separated(
                              itemCount: s!.length,
                              itemBuilder: (context, index) {
                                return SelfReflectionCard(
                                  selfReflection: s![index],
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
                    } else {
                      return EmptyData(
                          title: 'No Self Reflection Submitted',
                          subtitle: 'wait for submission from students');
                    }
                  },
                );
              }),
        ),
      ),
    );
  }
}
