import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/auth/auth_header.dart';
import 'package:elogbook/src/presentation/widgets/auth/input_password.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AuthHeader(
                height: 180,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sign Up",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Student ID'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('First Name'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Last Name'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
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
                    height: 16,
                  ),
                  InputPassword(label: 'Repeat Passsword'),
                  SizedBox(
                    height: 28,
                  ),
                  SizedBox(
                    width: AppSize.getAppWidth(context),
                    child: FilledButton(
                      onPressed: () {},
                      child: Text('Sign Up'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Center(child: Text('Already have an account?')),
                  Center(
                    child: InkWell(
                      onTap: () => context.back(),
                      child: Text(
                        'Login here',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
