import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/features/login/register_page.dart';
import 'package:elogbook/src/widgets/auth/auth_header.dart';
import 'package:elogbook/src/widgets/auth/input_password.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: AppSize.getAppWidth(context),
            height: AppSize.getAppHeight(context) - 56,
            child: Column(
              children: [
                AuthHeader(height: 240),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Login",
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            label: Text('Email'),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InputPassword(label: 'Passsword'),
                        SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot your password?',
                            style: textTheme.bodyMedium?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        SizedBox(
                          width: AppSize.getAppWidth(context),
                          child: FilledButton(
                            onPressed: () {},
                            child: Text('Login'),
                          ),
                        ),
                        Spacer(),
                        Text('Don\'t Have an Account?'),
                        InkWell(
                          onTap: () => context.navigateTo(RegisterPage()),
                          child: Text(
                            'Register',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
