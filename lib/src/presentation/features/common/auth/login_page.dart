import 'package:elogbook/src/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:elogbook/src/presentation/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
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
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) => onStateChange(state),
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
                      child: SpacingColumn(
                        onlyPading: true,
                        horizontalPadding: 28,
                        children: <Widget>[
                          _titleSection(),
                          const SizedBox(height: 20),
                          FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                _usernameFieldSection(),
                                const SizedBox(height: 16),
                                _passwordFieldSection(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          _forgotPasswordLinkSection(context),
                          const SizedBox(height: 28),
                          _submitButtonSection(context, state),
                          const Spacer(),
                          const Text('Don\'t Have an Account?'),
                          _registerLinkSection(context),
                          const SizedBox(height: 28),
                        ],
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

  Column _registerLinkSection(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  SizedBox _submitButtonSection(BuildContext context, LoginState state) {
    return SizedBox(
      width: AppSize.getAppWidth(context),
      child: FilledButton(
        onPressed: state is LoginLoading ? null : onLoginClick,
        child: Text(state is LoginLoading ? "Loading..." : "Login"),
      ),
    );
  }

  Align _forgotPasswordLinkSection(BuildContext context) {
    return Align(
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
    );
  }

  InputPassword _passwordFieldSection() {
    return InputPassword(
      name: 'password',
      label: 'Passsword',
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: 'This field is required',
        ),
      ]),
    );
  }

  FormBuilderTextField _usernameFieldSection() {
    return FormBuilderTextField(
      name: 'username',
      decoration: const InputDecoration(
        label: Text('Username or ID'),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: 'This field is required',
        ),
      ]),
    );
  }

  Align _titleSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Login",
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void onLoginClick() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      final authCubit = BlocProvider.of<LoginCubit>(context);
      authCubit.login(
        username: data['username'],
        password: data['password'],
      );
    }
  }

  void onStateChange(LoginState state) {
    if (state is LoginSuccess) {
      Future.microtask(() {
        BlocProvider.of<WrapperCubit>(context).isSignIn();
      });
      context.replace(const Wrapper());
    }

    if (state is LoginFailed) {
      CustomAlert.error(message: state.message, context: context);
      Future.microtask(() {
        BlocProvider.of<LoginCubit>(context).reset();
      });
    }
  }
}
