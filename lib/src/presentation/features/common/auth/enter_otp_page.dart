import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnterOtpPage extends StatefulWidget {
  final String email;
  final String newPassword;
  final String token;
  const EnterOtpPage({
    super.key,
    required this.newPassword,
    required this.email,
    required this.token,
  });

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) => TextEditingController());
    _focusNodes = List.generate(5, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void onOtpSubmitted() {
    String otp = '';
    _controllers.forEach((element) {
      otp += element.text;
    });
    otp.trim();
    BlocProvider.of<AuthCubit>(context).resetPassword(
      otp: otp,
      newPassword: widget.newPassword,
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          context.removeUntil(LoginPage());
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
                  SvgPicture.asset('assets/vectors/enter_otp_vector.svg'),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Enter OTP',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyLarge?.copyWith(
                        color: primaryTextColor,
                      ),
                      text: 'A 4 digit code has been sent to\n',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.back(),
                          text: widget.email,
                          style: textTheme.bodyLarge?.copyWith(
                            color: secondaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SpacingRow(
                    spacing: 6,
                    children: [
                      ...[
                        for (int i = 0; i < _controllers.length; i++)
                          OtpField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            onChanged: (e) {
                              if (_controllers[i].text.isNotEmpty &&
                                  i < _focusNodes.length - 1) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[i + 1]);
                              }
                            },
                          ),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onOtpSubmitted,
                      child: Text('Submit'),
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
}

class OtpField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onChanged;
  const OtpField({
    super.key,
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
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )),
        ),
      ),
    );
  }
}
