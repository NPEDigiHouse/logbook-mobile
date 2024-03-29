import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateSelfReflectionPage extends StatefulWidget {
  final UserCredential credential;
  const CreateSelfReflectionPage({super.key, required this.credential});

  @override
  State<CreateSelfReflectionPage> createState() =>
      _CreateSelfReflectionPageState();
}

class _CreateSelfReflectionPageState extends State<CreateSelfReflectionPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelfReflectionCubit, SelfReflectionState>(
      listener: (context, state) {
        if (state.isSelfReflectionPostSuccess) {
          BlocProvider.of<StudentCubit>(context)..getStudentSelfReflections();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Self-reflection Entry"),
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
                    if (widget.credential.student?.supervisingDPKId == null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Please select a supervisor first in the profile menu before creating a self reflection',
                          style: textTheme.bodyMedium?.copyWith(
                            color: errorColor,
                          ),
                        ),
                      ),
                    if (widget.credential.student?.supervisingDPKId !=
                        null) ...[
                      TextFormField(
                        minLines: 7,
                        maxLines: 7,
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                        controller: fieldController,
                        decoration: InputDecoration(
                          label: Text('Self-reflection Content'),
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
                    ]
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
            BlocProvider.of<SelfReflectionCubit>(context)
              ..uploadSelfReflection(
                  model:
                      SelfReflectionPostModel(content: fieldController.text));
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
