import 'package:flutter/material.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'self_reflection_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSelfReflectionsVerifiedPage extends StatefulWidget {
  const SupervisorListSelfReflectionsVerifiedPage({super.key});

  @override
  State<SupervisorListSelfReflectionsVerifiedPage> createState() =>
      _SupervisorListSelfReflectionsVerifiedPageState();
}

class _SupervisorListSelfReflectionsVerifiedPageState
    extends State<SupervisorListSelfReflectionsVerifiedPage> {
  ValueNotifier<List<SelfReflectionModel>> listStudent = ValueNotifier([]);
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<SelfReflectionSupervisorCubit>(context)
        ..getSelfReflectionsVerified(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: listStudent,
        builder: (context, s, _) {
          return BlocBuilder<SelfReflectionSupervisorCubit,
              SelfReflectionSupervisorState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Verified Self Reflections'),
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
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  )),
                            IconButton(
                              onPressed: () {
                                isSearchExpand.value = !value;

                                listStudent.value.clear();
                                listStudent.value = [...state.listData2!];
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
                      isMounted = false;
                      await Future.wait([
                        BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                            .getSelfReflectionsVerified(),
                      ]);
                    },
                    child: Builder(
                      builder: (context) {
                        if (state.listData2 == null) {
                          return const CustomLoading();
                        }
                        if (!isMounted) {
                          Future.microtask(() {
                            listStudent.value = [...state.listData2!];
                          });
                          isMounted = true;
                        }

                        return ValueListenableBuilder(
                            valueListenable: isSearchExpand,
                            builder: (context, status, _) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Builder(builder: (context) {
                                        if (s.isEmpty) {
                                          return const EmptyData(
                                            title:
                                                'No Self Reflection Submitted',
                                            subtitle:
                                                'wait for submission from students',
                                          );
                                        }
                                        return CustomScrollView(
                                          slivers: [
                                            if (status)
                                              const SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: 68,
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
                                                return SelfReflectionCard(
                                                  selfReflection: s[index],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: SearchField(
                                                  onChanged: (value) {
                                                    final data = state
                                                        .listData2!
                                                        .where((element) => element
                                                            .studentName!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                    if (value.isEmpty) {
                                                      listStudent.value.clear();
                                                      listStudent.value = [
                                                        ...state.listData2!
                                                      ];
                                                    } else {
                                                      listStudent.value = [
                                                        ...data
                                                      ];
                                                    }
                                                  },
                                                  onClear: () {
                                                    listStudent.value.clear();
                                                    listStudent.value = [
                                                      ...state.listData2!
                                                    ];
                                                  },
                                                  text: '',
                                                  hint: 'Search for student',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
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
            },
          );
        });
  }
}
