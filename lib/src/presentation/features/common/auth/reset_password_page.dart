import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/common/auth/enter_otp_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/auth/input_password.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  onNewPasswordSubmit() {
    if (passwordController.text.isEmpty) {
      return;
    }
    if (passwordController.text == repeatPasswordController.text) {
      context.navigateTo(EnterOtpPage(
        newPassword: passwordController.text,
        email: widget.email,
        token: widget.token,
      ));
    }
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
            children: [
              SvgPicture.asset('assets/vectors/reset_password_vector.svg'),
              SizedBox(
                height: 48,
              ),
              Text(
                'Reset\nPassword?',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 24,
              ),
              InputPassword(
                controller: passwordController,
                label: 'Password',
              ),
              SizedBox(
                height: 16,
              ),
              InputPassword(
                controller: repeatPasswordController,
                label: 'Repeat Password',
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onNewPasswordSubmit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
