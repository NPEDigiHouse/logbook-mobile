import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/widgets/sgl_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSglPage extends StatefulWidget {
  final bool isCeu;
  const SupervisorListSglPage({super.key, required this.isCeu});

  @override
  State<SupervisorListSglPage> createState() => _SupervisorListSglPageState();
}

class _SupervisorListSglPageState extends State<SupervisorListSglPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<SglCstCubit>(context)..getListSglStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Group Learing'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SglCstCubit>(context).getListSglStudents(),
            ]);
          },
          child: BlocBuilder<SglCstCubit, SglCstState>(
            builder: (context, state) {
              if (state.sglStudents == null) {
                return CustomLoading();
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
                      itemCount: state.sglStudents!.length,
                      itemBuilder: (context, index) {
                        return SglOnListCard(
                          sglCst: state.sglStudents![index],
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
      ),
    );
  }
}
