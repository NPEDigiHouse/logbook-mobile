import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/supervisor_self_reflection_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelfReflectionStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const SelfReflectionStudentPage({super.key, required this.student});

  @override
  State<SelfReflectionStudentPage> createState() =>
      _SelfReflectionStudentPageState();
}

class _SelfReflectionStudentPageState extends State<SelfReflectionStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SelfReflectionSupervisorCubit>(context, listen: false)
        ..getDetailSelfReflections(id: widget.student.studentId!);
    });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<SelfReflectionSupervisorCubit>(context,
                      listen: false)
                  .getDetailSelfReflections(id: widget.student.studentId!)
            ]);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              ...getHeadSection(
                  title: title,
                  subtitle: 'Self Reflections',
                  student: widget.student),
              BlocBuilder<SelfReflectionSupervisorCubit,
                  SelfReflectionSupervisorState>(
                builder: (context, state) {
                  if (state.data != null) {
                    if (state.data!.listSelfReflections!.isNotEmpty) {
                      return SliverList.separated(
                        itemCount: state.data!.listSelfReflections?.length,
                        itemBuilder: (context, index) {
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
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: EmptyData(
                            title: 'No Self Reflections',
                            subtitle: 'Empty data'),
                      );
                    }
                  } else {
                    return SliverToBoxAdapter(
                      child: CustomLoading(),
                    );
                  }
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
