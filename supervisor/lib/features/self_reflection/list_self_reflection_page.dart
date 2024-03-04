import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:supervisor/features/self_reflection/list_self_reflection_verified_page.dart';

import 'self_reflection_card.dart';
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
  ValueNotifier<bool> isSearchExpand = ValueNotifier(false);

  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<SelfReflectionSupervisorCubit>(context)
        ..getSelfReflections(),
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
                  title: const Text('Self Reflections'),
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
                                listStudent.value = [...state.listData!];
                              },
                              icon: const Icon(CupertinoIcons.search),
                            ),
                          ],
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.check_mark_circled),
                      onPressed: () {
                        context.navigateTo(
                            const SupervisorListSelfReflectionsVerifiedPage());
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
                            .getSelfReflections(),
                      ]);
                    },
                    child: Builder(
                      builder: (context) {
                        if (state.listData != null && !isMounted) {
                          Future.microtask(() {
                            listStudent.value = [...state.listData!];
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
                                        if (state.fetchState ==
                                            RequestState.loading) {
                                          return const CustomLoading();
                                        } else if (state.listData != null) {
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
                                        }
                                        return const CustomLoading();
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
                                                    final data = state.listData!
                                                        .where((element) => element
                                                            .studentName!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                    if (value.isEmpty) {
                                                      listStudent.value.clear();
                                                      listStudent.value = [
                                                        ...state.listData!
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
                                                      ...state.listData!
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
