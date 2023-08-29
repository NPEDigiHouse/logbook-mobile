import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/widgets/cst_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListCstPage extends StatefulWidget {
  final bool isCeu;
  const SupervisorListCstPage({super.key, required this.isCeu});

  @override
  State<SupervisorListCstPage> createState() => _SupervisorListCstPageState();
}

class _SupervisorListCstPageState extends State<SupervisorListCstPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<SglCstCubit>(context)..getListCstStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical Skill Training'),
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<SglCstCubit, SglCstState>(
          builder: (context, state) {
            if (state.cstStudents == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
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
                    child: UnitHeader(
                      unitName: 'Nama Unit',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 12,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SearchField(
                      onChanged: (value) {},
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
                    itemCount: state.cstStudents!.length,
                    itemBuilder: (context, index) {
                      return CstOnListCard(
                        sglCst: state.cstStudents![index],
                        isCeu: widget.isCeu,
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
        ),
      ),
    );
  }
}
