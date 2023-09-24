import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddScientificAssignmentPage extends StatefulWidget {
  final String unitName;
  const AddScientificAssignmentPage({super.key, required this.unitName});

  @override
  State<AddScientificAssignmentPage> createState() =>
      _AddScientificAssignmentPageState();
}

class _AddScientificAssignmentPageState
    extends State<AddScientificAssignmentPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  final _formKey = GlobalKey<FormBuilderState>();
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
        if (state.isUploadAssignmentSuccess) {
          BlocProvider.of<AssesmentCubit>(context)
              .getStudentScientificAssignment();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Scientific Assignment"),
        ).variant(),
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: FormBuilder(
                key: _formKey,
                child: SpacingColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  onlyPading: true,
                  horizontalPadding: 16,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    DepartmentHeader(unitName: widget.unitName),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: fieldController,
                      decoration: InputDecoration(
                        label: Text('Scientific assignment title'),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'This field is required',
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
                        isExpanded: true,
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
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
                      onPressed: onSubmit,
                      child: Text('Submit'),
                    ).fullWidth(),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.saveAndValidate() && locationId != null) {
      showDialog(
        context: context,
        barrierLabel: '',
        barrierDismissible: false,
        builder: (_) => VerifyDialog(
          onTap: () {
            BlocProvider.of<AssesmentCubit>(context)
              ..uploadScientificAssignment(
                model: MiniCexPostModel(
                    location: locationId,
                    miniCexPostModelCase: fieldController.text),
              );
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
