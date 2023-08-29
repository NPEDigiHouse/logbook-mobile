import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register success')),
          );

          state = Initial();

          context.replace(const LoginPage());
        }
        if (state is Failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register failed')),
          );

          state = Initial();
        }
      },
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
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
                                label: Text('Username'),
                              ),
                              validator: FormBuilderValidators.required(
                                errorText: 'This field is required',
                              ),
                            ),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
                              name: 'studentId',
                              decoration: const InputDecoration(
                                label: Text('Student ID'),
                              ),
                              validator: FormBuilderValidators.required(
                                errorText: 'This field is required',
                              ),
                            ),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
                              name: 'fullname',
                              decoration: const InputDecoration(
                                label: Text('Fullname'),
                              ),
                              validator: FormBuilderValidators.required(
                                errorText: 'This field is required',
                              ),
                            ),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
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
                            ),
                            const SizedBox(height: 16),
                            InputPassword(
                              name: 'password',
                              label: 'Password',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'This field is required',
                                ),
                                FormBuilderValidators.minLength(
                                  8,
                                  errorText: 'Must have at least 8 characters',
                                ),
                              ]),
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder(
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
                                      errorText:
                                          'Must be same as previous password',
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: AppSize.getAppWidth(context),
                        child: FilledButton(
                          onPressed: onRegisterClick,
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 16),
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

  void onRegisterClick() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      final authCubit = BlocProvider.of<AuthCubit>(context);

      authCubit.register(
        username: data['username'],
        studentId: data['studentId'],
        password: data['password'],
        email: data['email'],
        fullname: data['fullname'],
      );
    }
  }
}
