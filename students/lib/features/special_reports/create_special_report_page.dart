import 'package:core/context/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';

class CreateSpecialReportPage extends StatefulWidget {
  final String? id;
  final String? content;
  const CreateSpecialReportPage({super.key, this.content, this.id});

  @override
  State<CreateSpecialReportPage> createState() =>
      _CreateSpecialReportPageState();
}

class _CreateSpecialReportPageState extends State<CreateSpecialReportPage> {
  final TextEditingController fieldController = TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    if (widget.content != null) {
      fieldController.text = widget.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpecialReportCubit, SpecialReportState>(
      listener: (context, state) {
        if (state.isSuccessPostSpecialReport || state.isUpdateSpecialReport) {
          BlocProvider.of<SpecialReportCubit>(context)
              .getStudentSpecialReport();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Problem Consultation"),
        ).variant(),
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: FormBuilder(
                key: _formKey,
                child: SpacingColumn(
                  onlyPading: true,
                  horizontalPadding: 16,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Datetime'),
                        enabled: false,
                      ),
                      initialValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now()),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      minLines: 7,
                      maxLines: 7,
                      validator: FormBuilderValidators.required(
                        errorText: 'This field is required',
                      ),
                      maxLength: 500,
                      controller: fieldController,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        label: Text('Problems encountered, Solutions given'),
                      ),
                    ),
                    const Spacer(),
                    BlocSelector<SpecialReportCubit, SpecialReportState, bool>(
                      selector: (state) =>
                          state.createState == RequestState.loading,
                      builder: (context, isLoading) {
                        return FilledButton(
                          onPressed: isLoading ? null : onSubmit,
                          child: const Text('Submit'),
                        ).fullWidth();
                      },
                    ),
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

    if (_formKey.currentState!.saveAndValidate()) {
      showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
                onTap: () {
                  if (widget.content != null) {
                    BlocProvider.of<SpecialReportCubit>(context)
                        .updateSpecialReport(
                            content: fieldController.text, id: widget.id!);
                  } else {
                    BlocProvider.of<SpecialReportCubit>(context)
                        .postSpecialReport(content: fieldController.text);
                  }

                  Navigator.pop(context);
                },
              ));
    }
  }
}
