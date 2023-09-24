import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/forgot_password_page.dart';
import 'package:elogbook/src/presentation/features/common/auth/register_page.dart';
import 'package:elogbook/src/presentation/features/common/wrapper/wrapper.dart';
import 'package:elogbook/src/presentation/widgets/auth/auth_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Future.microtask(() {
            BlocProvider.of<AuthCubit>(context).isSignIn();
          });
          context.replace(const Wrapper());
          state = Initial();
        }

        if (state is Failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
          );

          state = Initial();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: AppSize.getAppWidth(context),
                height: AppSize.getAppHeight(context) - 56,
                child: Column(
                  children: <Widget>[
                    const AuthHeader(height: 240),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Login",
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  FormBuilderTextField(
                                    name: 'username',
                                    decoration: const InputDecoration(
                                      label: Text('Username or ID'),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: 'This field is required',
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(height: 16),
                                  InputPassword(
                                    name: 'password',
                                    label: 'Passsword',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: 'This field is required',
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  context.navigateTo(
                                    const ForgotPasswordPage(),
                                  );
                                },
                                child: Text(
                                  'Forgot your password?',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: AppSize.getAppWidth(context),
                              child: FilledButton(
                                onPressed: onLoginClick,
                                child: Text(
                                    state is Loading ? "Loading..." : "Login"),
                              ),
                            ),
                            const Spacer(),
                            const Text('Don\'t Have an Account?'),
                            InkWell(
                              onTap: () {
                                context.replace(const RegisterPage());
                              },
                              child: Text(
                                'Register',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onLoginClick() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      final authCubit = BlocProvider.of<AuthCubit>(context);

      authCubit.login(
        username: data['username'],
        password: data['password'],
      );
    }
  }
}
