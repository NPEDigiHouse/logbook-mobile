import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  const AddScientificAssignmentPage({super.key, required this.unitName});

  @override
  State<AddScientificAssignmentPage> createState() => _AddScientificAssignmentPageState();
}

class _AddScientificAssignmentPageState extends State<AddScientificAssignmentPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  int? locationId;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<ActivityCubit>(context)..getActivityLocations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.isUploadMiniCexSuccess) {
          // BlocProvider.of<AssesmentCubit>(context)..();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Mini Cex"),
        ).variant(),
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                onlyPading: true,
                horizontalPadding: 16,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  UnitHeader(unitName: widget.unitName),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: fieldController,
                    decoration: InputDecoration(
                      label: Text('Case Title'),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  BlocBuilder<ActivityCubit, ActivityState>(
                      builder: (context, state) {
                    List<ActivityModel> _activityLocations = [];
                    if (state.activityLocations != null) {
                      _activityLocations.clear();
                      _activityLocations.addAll(state.activityLocations!);
                    }
                    return DropdownButtonFormField(
                      hint: Text('Location'),
                      items: _activityLocations
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) locationId = v.id!;
                      },
                      value: null,
                    );
                  }),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (fieldController.text.isNotEmpty &&
                          locationId != null) {
                        BlocProvider.of<AssesmentCubit>(context)
                          ..uploadMiniCex(
                            model: MiniCexPostModel(
                                location: locationId,
                                miniCexPostModelCase: fieldController.text),
                          );
                      }
                    },
                    child: Text('Submit'),
                  ).fullWidth(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
