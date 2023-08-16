import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/select_units/widgets/custom_bottom_alert.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/select_units/widgets/select_unit_card.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectUnitPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;
  const SelectUnitPage({super.key, required this.activeUnitModel});

  @override
  State<SelectUnitPage> createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UnitCubit>(context, listen: false)..fetchUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select Unit"),
        leading: IconButton(
          onPressed: () => context.back(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sort_by_alpha,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<UnitCubit, UnitState>(
          listener: (context, state) {
            if (state is ChangeActiveSuccess) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return CustomBottomAlert(
                    message: 'Successfully replaced unit!',
                  );
                },
              ).whenComplete(() {
                BlocProvider.of<UnitCubit>(context, listen: false)
                    .getActiveUnit();
                Navigator.pop(context); // Jika ini adalah tujuan yang benar
              });
            }
          },
          builder: (context, state) {
            if (state is FetchSuccess) {
              // print(state.units);
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemBuilder: (context, index) {
                  return SelectUnitCard(
                    unitName: state.units[index].name,
                    unitId: state.units[index].id,
                    activeUnitId: widget.activeUnitModel.unitId ?? '',
                  );
                },
                itemCount: state.units.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
