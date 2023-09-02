import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/supervisor_self_reflection_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorSelfReflectionStudentPage extends StatefulWidget {
  final String studentId;
  const SupervisorSelfReflectionStudentPage(
      {super.key, required this.studentId});

  @override
  State<SupervisorSelfReflectionStudentPage> createState() =>
      _SupervisorSelfReflectionStudentPageState();
}

class _SupervisorSelfReflectionStudentPageState
    extends State<SupervisorSelfReflectionStudentPage> {
  @override
  void initState() {
    super.initState();
    print(widget.studentId);
    BlocProvider.of<SelfReflectionSupervisorCubit>(context)
      ..getDetailSelfReflections(id: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Self Reflecton'),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  .getDetailSelfReflections(id: widget.studentId)
            ]);
          },
          child: BlocConsumer<SelfReflectionSupervisorCubit,
              SelfReflectionSupervisorState>(
            listener: (context, state) {
              if (state.requestStateVerifiy == RequestState.data) {
                BlocProvider.of<SelfReflectionSupervisorCubit>(context)
                  ..getDetailSelfReflections(id: widget.studentId)
                  ..reset();
              }
            },
            builder: (context, state) {
              if (state.data == null) {
                return CustomLoading();
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.data!.studentName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'NIM',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.data!.studentId ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SectionDivider(),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 12,
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.data!.listSelfReflections?.length,
                    itemBuilder: (context, index) {
                      print(state.data!.listSelfReflections);
                      return SupervisorSelfReflectionCard(
                        data: state.data!.listSelfReflections![index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
