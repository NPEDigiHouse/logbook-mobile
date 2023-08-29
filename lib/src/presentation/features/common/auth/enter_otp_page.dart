import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';

class EnterOtpPage extends StatefulWidget {
  final String email;
  final String newPassword;
  final String token;

  const EnterOtpPage({
    super.key,
    required this.email,
    required this.newPassword,
    required this.token,
  });

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    _focusNodes = List.generate(5, (_) => FocusNode());
    _controllers = List.generate(5, (_) => TextEditingController());

    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          context.removeUntil(const LoginPage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ForgotPasswordHeader(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                horizontalPadding: 24,
                children: [
                  SvgPicture.asset(
                    AssetPath.getVector('enter_otp_vector.svg'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Enter OTP',
                    textAlign: TextAlign.left,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyLarge?.copyWith(
                        color: primaryTextColor,
                      ),
                      text: 'A 5 digit code has been sent to\n',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString('googlegmail://'),
                          text: widget.email,
                          style: textTheme.bodyLarge?.copyWith(
                            color: secondaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FormBuilder(
                    key: _formKey,
                    child: SpacingRow(
                      spacing: 6,
                      children: [
                        for (var i = 0; i < 5; i++)
                          OtpField(
                            name: i.toString(),
                            focusNode: _focusNodes[i],
                            controller: _controllers[i],
                            onChanged: (e) {
                              if (_controllers[i].text.isNotEmpty) {
                                if (i < _focusNodes.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[i + 1]);
                                } else {
                                  FocusScope.of(context).unfocus();

                                  onOtpSubmitted();
                                }
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onOtpSubmitted,
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onOtpSubmitted() {
    if (_formKey.currentState!.saveAndValidate()) {
      final values =
          _formKey.currentState!.value.values.map((e) => e.toString()).toList();

      final otp = values.join('').trim();

      BlocProvider.of<AuthCubit>(context).resetPassword(
        otp: otp,
        newPassword: widget.newPassword,
        token: widget.token,
      );
    }
  }
}

class OtpField extends StatelessWidget {
  final String name;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String?)? onChanged;

  const OtpField({
    super.key,
    required this.name,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: dividerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FormBuilderTextField(
          name: name,
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
          ),
          decoration: InputDecoration(
            counterText: '',
            errorStyle: const TextStyle(height: 0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: FormBuilderValidators.required(
            errorText: '',
          ),
        ),
      ),
    );
  }
}
