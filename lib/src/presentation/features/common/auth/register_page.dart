import 'package:elogbook/src/presentation/blocs/register_cubit/register_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/widgets/auth/auth_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_password.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) => onStateChange(state),
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: AuthHeader(height: 180),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      _titleSection(),
                      const SizedBox(height: 20),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _usernameFieldSection(),
                            const SizedBox(height: 16),
                            _studentIdFieldSection(),
                            const SizedBox(height: 16),
                            _fullnameFieldSection(),
                            const SizedBox(height: 16),
                            _emailFieldSection(),
                            const SizedBox(height: 16),
                            _passwordFieldSection(),
                            const SizedBox(height: 16),
                            _repeatFieldSection(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _submitButton(context, state),
                      const SizedBox(height: 16),
                      _loginLinkSection(context),
                      const SizedBox(height: 28),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _loginLinkSection(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Already have an account?'),
        ),
        Center(
          child: InkWell(
            onTap: () => context.replace(const LoginPage()),
            child: Text(
              'Login here',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context, RegisterState state) {
    return SizedBox(
      width: AppSize.getAppWidth(context),
      child: FilledButton(
        onPressed: onRegisterClick,
        child: Text(
          state is RegisterLoading ? "Loading..." : "Sign Up",
        ),
      ),
    );
  }

  Widget _repeatFieldSection() {
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

  Widget _emailFieldSection() {
    return FormBuilderTextField(
      name: 'email',
      decoration: const InputDecoration(
        label: Text('Email'),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: 'This field is required',
        ),
        FormBuilderValidators.email(
          errorText: 'Invalid Email Address',
        ),
      ]),
    );
  }

  Widget _fullnameFieldSection() {
    return FormBuilderTextField(
      name: 'fullname',
      decoration: const InputDecoration(
        label: Text('Fullname'),
      ),
      validator: FormBuilderValidators.required(
        errorText: 'This field is required',
      ),
    );
  }

  Widget _studentIdFieldSection() {
    return FormBuilderTextField(
      name: 'studentId',
      decoration: const InputDecoration(
        label: Text('Student ID'),
      ),
      validator: FormBuilderValidators.required(
        errorText: 'This field is required',
      ),
    );
  }

  Widget _usernameFieldSection() {
    return FormBuilderTextField(
      name: 'username',
      decoration: const InputDecoration(
        label: Text('Username'),
      ),
      validator: FormBuilderValidators.required(
        errorText: 'This field is required',
      ),
    );
  }

  Widget _titleSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Sign Up",
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void onRegisterClick() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      final authCubit = BlocProvider.of<RegisterCubit>(context);
      authCubit.register(
        username: data['username'],
        studentId: data['studentId'],
        password: data['password'],
        email: data['email'],
        fullname: data['fullname'],
      );
    }
  }

  void onStateChange(RegisterState state) {
    if (state is RegisterSuccess) {
      CustomAlert.success(message: 'Register success', context: context);
      state = RegisterInitial();
      context.replace(const LoginPage());
    }
    if (state is RegisterFailed) {
      CustomAlert.error(message: state.message, context: context);
      state = RegisterInitial();
    }
  }
}
