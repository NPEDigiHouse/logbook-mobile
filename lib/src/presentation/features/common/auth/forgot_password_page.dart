import 'package:elogbook/src/presentation/blocs/reset_password_cubit/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/common/auth/reset_password_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late GlobalKey<FormBuilderState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) => onTokenGenerated(state),
      builder: (context, state) {
        return Scaffold(
          appBar: ForgotPasswordHeader(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                horizontalPadding: 24,
                children: [
                  _titleSection(),
                  const SizedBox(height: 24),
                  _emailFieldSection(),
                  const SizedBox(height: 32),
                  _submitButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetPath.getVector('forgot_password_vector.svg'),
        ),
        Text(
          'Forgot\nPassword?',
          textAlign: TextAlign.left,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Don’t worry! It happens. Please enter the address associated with your account.',
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  SizedBox _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onResetPasswordSubmit,
        child: const Text('Submit'),
      ),
    );
  }

  FormBuilder _emailFieldSection() {
    return FormBuilder(
      key: _formKey,
      child: FormBuilderTextField(
        name: 'email',
        decoration: const InputDecoration(
          label: Text('Email'),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: 'This field is required',
          ),
          FormBuilderValidators.email(
            errorText: 'Invalid Email Address',
          ),
        ]),
      ),
    );
  }

  void onResetPasswordSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.saveAndValidate()) {
      BlocProvider.of<ResetPasswordCubit>(context).generateTokenResetPassword(
        email: _formKey.currentState!.value['email'],
      );
    }
  }

  void onTokenGenerated(ResetPasswordState state) {
    if (state is GenerateTokenResetPassword) {
      context.navigateTo(
        ResetPasswordPage(
          email: _formKey.currentState!.value['email'],
          token: state.token,
        ),
      );
      state = ResetInitial();
    }
  }
}
