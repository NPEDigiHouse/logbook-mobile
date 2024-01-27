import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/skeleton/list_skeleton_template.dart';
import 'widgets/select_unit_card.dart';

class SelectDepartmentPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  const SelectDepartmentPage({super.key, required this.activeDepartmentModel});

  @override
  State<SelectDepartmentPage> createState() => _SelectDepartmentPageState();
}

class _SelectDepartmentPageState extends State<SelectDepartmentPage> {
  bool sortAZ = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DepartmentCubit>(context, listen: false)
        .fetchStudentDepartments(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<DepartmentCubit>(context, listen: false)
            .getActiveDepartment();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Select Department"),
          leading: IconButton(
            onPressed: () {
              BlocProvider.of<DepartmentCubit>(context, listen: false)
                  .getActiveDepartment();
              context.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<DepartmentCubit>(context, listen: false)
                    .fetchStudentDepartments(sortAZ);
                sortAZ = !sortAZ;
              },
              icon: const Icon(
                Icons.sort_by_alpha,
                color: primaryColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<DepartmentCubit, DepartmentState>(
            listener: (context, state) {
              if (state is ChangeActiveSuccess) {
                CustomAlert.success(
                    context: context,
                    message: 'Successfully replaced depeartment!');
                BlocProvider.of<DepartmentCubit>(context, listen: false)
                    .getActiveDepartment()
                    .whenComplete(() => Navigator.pop(context));
              } else if (state is ChangeActiveFailed) {
                CustomAlert.error(
                    context: context, message: 'Failed to change active unit');
                BlocProvider.of<DepartmentCubit>(context, listen: false)
                    .getActiveDepartment()
                    .whenComplete(() => Navigator.pop(context));
              }
            },
            builder: (context, state) {
              if (state is StudentUnitFetchSuccess) {
                final notAvailable = state.units.units!
                    .where((element) => element.isDone!)
                    .toList();
                final available = state.units.units!
                    .where((element) => !element.isDone! && !element.isActive!)
                    .toList();
                final active =
                    state.units.units!.where((element) => element.isActive!);
                final merge = [...active, ...available, ...notAvailable];
                return ListView.separated(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    return SelectDepartmentCard(
                      unitName: merge[index].name,
                      unitId: merge[index].id,
                      isAllow: state.units.isAllowSelect!,
                      activeDepartmentId:
                          widget.activeDepartmentModel.unitId ?? '',
                      isDone: merge[index].isDone!,
                    );
                  },
                  itemCount: merge.length,
                );
              } else {
                return ListSkeletonTemplate(
                  listHeight: List.generate(9, (index) => 70),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  spacing: 16,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
