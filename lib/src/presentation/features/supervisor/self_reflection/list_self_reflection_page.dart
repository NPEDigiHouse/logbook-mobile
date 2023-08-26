import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_card.dart';
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
        child: BlocBuilder<SelfReflectionSupervisorCubit,
            SelfReflectionSupervisorState>(
          builder: (context, state) {
            if (state.listData == null) {
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
                    itemCount: state.listData!.length,
                    itemBuilder: (context, index) {
                      return SelfReflectionCard(
                        selfReflection: state.listData![index],
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
