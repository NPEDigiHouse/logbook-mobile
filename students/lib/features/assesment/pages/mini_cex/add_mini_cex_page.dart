import 'package:core/context/navigation_extension.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:data/models/assessment/mini_cex_detail_model.dart';
import 'package:data/models/assessment/mini_cex_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';

class AddMiniCexPage extends StatefulWidget {
  final String unitName;
  final MiniCexStudentDetailModel? oldData;

  const AddMiniCexPage({super.key, required this.unitName, this.oldData});

  @override
  State<AddMiniCexPage> createState() => _AddMiniCexPageState();
}

class _AddMiniCexPageState extends State<AddMiniCexPage> {
  final TextEditingController fieldController = TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  int? locationId;
  final _formKey = GlobalKey<FormBuilderState>();
  ActivityModel? locationVal;

  @override
  void initState() {
    super.initState();
    if (widget.oldData != null) {
      fieldController.text = widget.oldData?.dataCase ?? '';
    }
    Future.microtask(
        () => BlocProvider.of<ActivityCubit>(context)..getActivityLocations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.isUploadMiniCexSuccess) {
          CustomAlert.success(
              message: 'Success Add Mini-CEX', context: context);
          BlocProvider.of<AssesmentCubit>(context).getStudentMiniCexs();
          Navigator.pop(context);
        }
        if (state.isUpdate) {
          CustomAlert.success(
              message: 'Success Update Mini-CEX', context: context);
          BlocProvider.of<AssesmentCubit>(context).getStudentMiniCexs();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Mini Cex"),
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
                    const SizedBox(
                      height: 16,
                    ),
                    DepartmentHeader(unitName: widget.unitName),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: fieldController,
                      decoration: const InputDecoration(
                        label: Text('Case Title (Required)'),
                      ),
                      maxLength: 100,
                      validator: FormBuilderValidators.required(
                        errorText: 'This field is required',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    BlocBuilder<ActivityCubit, ActivityState>(
                        builder: (context, state) {
                      List<ActivityModel> activityLocations = [];
                      if (state.activityLocations != null) {
                        activityLocations.clear();
                        activityLocations.addAll(state.activityLocations!);
                        if (widget.oldData != null) {
                          int index = activityLocations.indexWhere((element) =>
                              element.name == widget.oldData?.location);
                          if (index != -1) {
                            locationId = activityLocations[index].id;
                            locationVal = activityLocations[index];
                          }
                        }
                      }
                      return DropdownButtonFormField(
                        hint: const Text('Location'),
                        isExpanded: true,
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                        decoration:
                            InputDecoration(label: Text('Location (Required)')),
                        items: activityLocations
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name!),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) locationId = v.id!;
                        },
                        value: locationVal,
                      );
                    }),
                    const Spacer(),
                    FilledButton(
                      onPressed: onSubmit,
                      child: const Text('Submit'),
                    ).fullWidth(),
                    const SizedBox(
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
      if (widget.oldData != null) {
        //EDIT
        showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
            onTap: () {
              BlocProvider.of<AssesmentCubit>(context).updateMiniCex(
                model: MiniCexPostModel(
                    location: locationId,
                    miniCexPostModelCase: fieldController.text),
                id: widget.oldData?.id ?? '',
              );
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
            onTap: () {
              BlocProvider.of<AssesmentCubit>(context).uploadMiniCex(
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
}
