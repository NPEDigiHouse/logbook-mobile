import 'package:core/context/navigation_extension.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inputs/search_field.dart';

import 'widgets/select_department_sheet.dart';
import 'widgets/sgl_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSglPage extends StatefulWidget {
  final bool isCeu;
  final String userId;
  const SupervisorListSglPage(
      {super.key, required this.isCeu, required this.userId});

  @override
  State<SupervisorListSglPage> createState() => _SupervisorListSglPageState();
}

class _SupervisorListSglPageState extends State<SupervisorListSglPage> {
  String? filterUnitId;
  final ValueNotifier<List<SglCstOnList>> listSglCstStudents =
      ValueNotifier([]);
  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    filterUnitId = null;
    isMounted = false;

    Future.microtask(
      () => BlocProvider.of<SglCstCubit>(context)..getListSglStudents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Small Group Learning'),
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
                    isMounted = false;
                    BlocProvider.of<SglCstCubit>(context)
                        .getListSglStudents(unitId: f);
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
            isMounted = false;
            await Future.wait([
              BlocProvider.of<SglCstCubit>(context)
                  .getListSglStudents(unitId: filterUnitId),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listSglCstStudents,
              builder: (context, s, _) {
                return BlocBuilder<SglCstCubit, SglCstState>(
                  builder: (context, state) {
                    if (state.sglStudents == null) {
                      return const CustomLoading();
                    }
                    if (!isMounted) {
                      Future.microtask(() {
                        listSglCstStudents.value = [...state.sglStudents!];
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
                                final data = state.sglStudents!
                                    .where((element) => element.studentName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                if (value.isEmpty) {
                                  listSglCstStudents.value.clear();
                                  listSglCstStudents.value = [
                                    ...state.sglStudents!
                                  ];
                                } else {
                                  listSglCstStudents.value = [...data];
                                }
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
                            itemCount: s.length,
                            itemBuilder: (context, index) {
                              return SglOnListCard(
                                sglCst: s[index],
                                isCeu: widget.isCeu,
                                userId: widget.userId,
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
