import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/auth_header.dart';
import 'package:elogbook/src/presentation/widgets/auth/input_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  String? usernameError;
  String? studentIdError;
  String? passwordError;
  String? emailError;
  String? repeatPasswordError;

  void onRegisterClick() {
    bool isError = false;
    usernameError = null;
    studentIdError = null;
    passwordError = null;
    emailError == null;
    repeatPasswordError == null;
    if (usernameController.text.isEmpty) {
      usernameError = "Username cannot be empty";
      isError = true;
    }
    if (studentIdController.text.isEmpty) {
      studentIdError = "Student id cannot be empty";
      isError = true;
    }
    if (passwordController.text.isEmpty) {
      passwordError = "Password cannot be empty";
      isError = true;
    }

    if (emailController.text.isEmpty) {
      emailError = "Email cannot be empty";
      isError = true;
    }

    if (passwordController.text != repeatPasswordController.text) {
      repeatPasswordError = 'Password do not match';
      isError = true;
    }

    if (isError) {
      setState(() {});
      return;
    }
    final authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.register(
      username: usernameController.text,
      studentId: studentIdController.text,
      password: passwordController.text,
      email: emailController.text,
      fullname: fullnameController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is RegisterSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register successful')),
        );
        state = Initial();
        context.replace(LoginPage());
      }
      if (state is Failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register failed')),
        );
        state = Initial();
      }
    }, builder: (context, state) {
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        label: Text('Username'),
                        errorText: usernameError,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: studentIdController,
                      decoration: InputDecoration(
                        label: Text('Student ID'),
                        errorText: studentIdError,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        label: Text('Fullname'),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        label: Text('Email'),
                        errorText: emailError,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InputPassword(
                      controller: passwordController,
                      label: 'Password',
                      errorText: passwordError,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InputPassword(
                      controller: repeatPasswordController,
                      label: 'Repeat Passsword',
                      errorText: repeatPasswordError,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    SizedBox(
                      width: AppSize.getAppWidth(context),
                      child: FilledButton(
                        onPressed: onRegisterClick,
                        child: Text('Sign Up'),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(child: Text('Already have an account?')),
                    Center(
                      child: InkWell(
                        onTap: () => context.replace(LoginPage()),
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
    });
  }
}
