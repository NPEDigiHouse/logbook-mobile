import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/special_report/widgets/special_report_student_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListSpecialReportPage extends StatefulWidget {
  const SupervisorListSpecialReportPage({super.key});

  @override
  State<SupervisorListSpecialReportPage> createState() =>
      _SupervisorListSpecialReportPageState();
}

class _SupervisorListSpecialReportPageState
    extends State<SupervisorListSpecialReportPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<SpecialReportCubit>(context)
      ..getSpecialReportStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Reports'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SpecialReportCubit>(context)
                  .getSpecialReportStudents(),
            ]);
          },
          child: BlocBuilder<SpecialReportCubit, SpecialReportState>(
            builder: (context, state) {
              if (state.specialReportStudents == null) {
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
                      itemCount: state.specialReportStudents!.length,
                      itemBuilder: (context, index) {
                        return SpecialReportStudentCard(
                          sr: state.specialReportStudents![index],
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
