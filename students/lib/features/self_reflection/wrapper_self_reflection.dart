import 'package:core/context/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'self_reflection_detail_page.dart';

class WrapperSelfReflection extends StatefulWidget {
  final String srId;
  const WrapperSelfReflection({super.key, required this.srId});

  @override
  State<WrapperSelfReflection> createState() => _WrapperSelfReflectionState();
}

class _WrapperSelfReflectionState extends State<WrapperSelfReflection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentCubit>(context).getStudentSelfReflections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entry Detail"),
      ),
      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state.selfReflectionResponse != null) {
            context.navigateTo(
              DetailSelfReflectionPage(
                model: state.selfReflectionResponse!.listSelfReflections!
                    .firstWhere(
                        (element) => element.selfReflectionId == widget.srId),
              ),
            );
          }
        },
        child: const CustomLoading(),
      ),
    );
  }
}
