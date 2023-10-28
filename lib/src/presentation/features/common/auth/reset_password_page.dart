import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/common/auth/enter_otp_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_password.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final ValueNotifier<String> _passwordNotifier;

  @override
  void initState() {
    _passwordNotifier = ValueNotifier('');
    super.initState();
  }

  @override
  void dispose() {
    _passwordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForgotPasswordHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SpacingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            horizontalPadding: 24,
            children: <Widget>[
              _titleSection(),
              const SizedBox(height: 24),
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _passwordFieldSection(),
                    const SizedBox(height: 16),
                    _repeatPasswordFieldSection(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _submitButtonSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButtonSection() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onNewPasswordSubmit,
        child: const Text('Submit'),
      ),
    );
  }

  Widget _repeatPasswordFieldSection() {
    return ValueListenableBuilder(
      valueListenable: _passwordNotifier,
      builder: (context, password, child) {
        return InputPassword(
          name: 'repeatPassword',
          label: 'Repeat Password',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'This field is required',
            ),
            FormBuilderValidators.equal(
              password,
              errorText: 'Must be same as previous password',
            ),
          ]),
        );
      },
    );
  }

  Widget _passwordFieldSection() {
    return InputPassword(
      name: 'password',
      label: 'Password',
      onChange: (value) {
        _passwordNotifier.value = value ?? '';
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: 'This field is required',
        ),
        FormBuilderValidators.minLength(
          8,
          errorText: 'Must have at least 8 characters',
        ),
      ]),
    );
  }

  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetPath.getVector('reset_password_vector.svg'),
        ),
        const SizedBox(height: 48),
        Text(
          'Reset\nPassword?',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  void onNewPasswordSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      context.navigateTo(
        EnterOtpPage(
          newPassword: data['password'],
          email: widget.email,
          token: widget.token,
        ),
      );
    }
  }
}
