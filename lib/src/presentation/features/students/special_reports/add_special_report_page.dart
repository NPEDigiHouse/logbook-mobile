import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class AddSpecialReportPage extends StatefulWidget {
  const AddSpecialReportPage({super.key});

  @override
  State<AddSpecialReportPage> createState() => _AddSpecialReportPageState();
}

class _AddSpecialReportPageState extends State<AddSpecialReportPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpecialReportCubit, SpecialReportState>(
      listener: (context, state) {
        if (state.isSuccessPostSpecialReport) {
          BlocProvider.of<SpecialReportCubit>(context)
            ..getStudentSpecialReport();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Problem Consultation"),
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
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Datetime'),
                        enabled: false,
                      ),
                      initialValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now()),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      minLines: 7,
                      maxLines: 7,
                      validator: FormBuilderValidators.required(
                        errorText: 'This field is required',
                      ),
                      controller: fieldController,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        label: Text('Problems encountered, Solutions given'),
                      ),
                    ),
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

    if (_formKey.currentState!.saveAndValidate()) {
      showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
                onTap: () {
                  BlocProvider.of<SpecialReportCubit>(context)
                    ..postSpecialReport(content: fieldController.text);
                  Navigator.pop(context);
                },
              ));
    }
  }
}
