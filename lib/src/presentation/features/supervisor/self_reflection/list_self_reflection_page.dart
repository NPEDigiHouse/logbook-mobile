import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_card.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListSelfReflectionsPage extends StatefulWidget {
  const ListSelfReflectionsPage({super.key});

  @override
  State<ListSelfReflectionsPage> createState() =>
      _ListSelfReflectionsPageState();
}

class _ListSelfReflectionsPageState extends State<ListSelfReflectionsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SelfReflectionSupervisorCubit>(context)
      ..getSelfReflections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Session'),
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
                    child: SearchField(
                      onChanged: (value) {},
                      text: 'Search',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
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
