import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/widgets/cst_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/widgets/select_department_sheet.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
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

  ValueNotifier<List<SglCstOnList>> listSglCstStudents = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    filterUnitId = null;
    isMounted = false;
    Future.microtask(
        () => BlocProvider.of<SglCstCubit>(context).getListCstStudents());
  }

  @override
  void dispose() {
    super.dispose();
    listSglCstStudents.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical Skill Training'),
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
                        .getListCstStudents(unitId: f);
                    Navigator.pop(context);
                  },
                ),
              );
            },
            icon: Icon(
              CupertinoIcons.line_horizontal_3_decrease,
            ),
          )
        ],
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          isMounted = false;
          await Future.wait([
            BlocProvider.of<SglCstCubit>(context)
                .getListCstStudents(unitId: filterUnitId),
          ]);
        },
        child: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: listSglCstStudents,
              builder: (context, s, _) {
                return BlocBuilder<SglCstCubit, SglCstState>(
                  builder: (context, state) {
                    if (state.cstStudents == null) {
                      return CustomLoading();
                    }
                    if (!isMounted) {
                      Future.microtask(() {
                        listSglCstStudents.value = [...state.cstStudents!];
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
                                final data = state.cstStudents!
                                    .where((element) => element.studentName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                if (value.isEmpty) {
                                  listSglCstStudents.value.clear();
                                  listSglCstStudents.value = [
                                    ...state.cstStudents!
                                  ];
                                } else {
                                  listSglCstStudents.value = [...data];
                                }
                              },
                              onSubmited: (value) {},
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
                            itemCount: s.length,
                            itemBuilder: (context, index) {
                              return CstOnListCard(
                                sglCst: s[index],
                                isCeu: widget.isCeu,
                                userId: widget.userId,
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
