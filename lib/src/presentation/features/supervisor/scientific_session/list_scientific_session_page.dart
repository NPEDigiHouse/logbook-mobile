import 'package:elogbook/core/context/navigation_extension.dart';
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
          await Future.wait([
            BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                .getScientificSessionList(),
          ]);
        },
        child: SafeArea(
          child: BlocBuilder<ScientificSessionSupervisorCubit,
              ScientificSessionSupervisorState>(
            builder: (context, state) {
              if (state.listData == null) {
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
                        return ScientificSessionCard(
                          scientificSession: state.listData![index],
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
