import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/models/units/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/widgets/skeleton/list_skeleton_template.dart';
import 'widgets/custom_bottom_alert.dart';
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
        .fetchDepartments(true);
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
                    .fetchDepartments(sortAZ);
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
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return const CustomBottomAlert(
                      message: 'Successfully replaced unit!',
                    );
                  },
                ).whenComplete(() {
                  BlocProvider.of<DepartmentCubit>(context, listen: false)
                      .getActiveDepartment();
                  Navigator.pop(context); // Jika ini adalah tujuan yang benar
                });
              } else if (state is ChangeActiveFailed) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return const CustomBottomAlert(
                      message: 'Failed to change active unit',
                      isFailed: true,
                    );
                  },
                ).whenComplete(() {
                  BlocProvider.of<DepartmentCubit>(context, listen: false)
                      .getActiveDepartment();
                  Navigator.pop(context); // Jika ini adalah tujuan yang benar
                });
              }
            },
            builder: (context, state) {
              if (state is FetchSuccess) {
                final List<DepartmentModel> data = [
                  if (widget.activeDepartmentModel.unitId != null)
                    DepartmentModel(
                      id: widget.activeDepartmentModel.unitId!,
                      name: widget.activeDepartmentModel.unitName!,
                    ),
                  ...state.units
                      .where((element) =>
                          element.id != widget.activeDepartmentModel.unitId)
                      .toList()
                ];
                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    return SelectDepartmentCard(
                      unitName: data[index].name,
                      unitId: data[index].id,
                      activeDepartmentId:
                          widget.activeDepartmentModel.unitId ?? '',
                    );
                  },
                  itemCount: state.units.length,
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
