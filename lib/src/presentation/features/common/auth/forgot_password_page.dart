import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/reset_password_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/forgot_password_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  void onResetPasswordSubmit() {
    if (emailController.text.isNotEmpty) {
      BlocProvider.of<AuthCubit>(context)
          .generateTokenResetPassword(email: emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is GenerateTokenResetPassword) {
        context.navigateTo(
          ResetPasswordPage(
            email: emailController.text,
            token: state.token,
          ),
        );
        state = Initial();
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: ForgotPasswordHeader(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              horizontalPadding: 24,
              children: [
                SvgPicture.asset('assets/vectors/forgot_password_vector.svg'),
                Text(
                  'Forgot\nPassword?',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Don’t worry! It happens. Please enter the address associated with your account.',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    label: Text('Email'),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onResetPasswordSubmit,
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
