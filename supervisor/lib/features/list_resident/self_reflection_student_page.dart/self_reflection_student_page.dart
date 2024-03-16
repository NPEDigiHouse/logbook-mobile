import 'package:core/styles/color_palette.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';

import '../widgets/head_resident_page.dart';
import '../../self_reflection/supervisor_self_reflection_card.dart';
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
          .getDetailSelfReflections2(id: widget.student.studentId!);
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
                  .getDetailSelfReflections2(id: widget.student.studentId!)
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
                  if (state.data2 != null) {
                    if (state.data2!.listSelfReflections!.isNotEmpty) {
                      return SliverList.separated(
                        itemCount: state.data2!.listSelfReflections?.length,
                        itemBuilder: (context, index) {
                          return SupervisorSelfReflectionCard(
                            data: state.data2!.listSelfReflections![index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                      );
                    } else {
                      return const SliverToBoxAdapter(
                        child: EmptyData(
                            title: 'No Self Reflections',
                            subtitle: 'Empty data'),
                      );
                    }
                  } else {
                    return const SliverToBoxAdapter(
                      child: CustomLoading(),
                    );
                  }
                },
              ),
              const SliverToBoxAdapter(
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
