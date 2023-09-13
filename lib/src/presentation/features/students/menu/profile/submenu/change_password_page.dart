import 'dart:ui';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/password_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _repeatPasswordController;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state.isResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Success reset password')),
          );
          await BlocProvider.of<ProfileCubit>(context).reset();
          await BlocProvider.of<AuthCubit>(context).logout();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Change Password'),
          backgroundColor: scaffoldBackgroundColor.withAlpha(200),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PasswordFormField(
                        controller: _newPasswordController,
                        label: 'New Password',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Field can\'t be empty.';
                          }

                          if (value.length < 8) {
                            return 'Password must have at least 8 characters.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      PasswordFormField(
                        controller: _repeatPasswordController,
                        label: 'Repeat New Password',
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Field can\'t be empty.';
                          }

                          if (value != _newPasswordController.text) {
                            return 'Password do not match.';
                          }

                          return null;
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ProfileCubit>(context)
                                ..resetPassword(
                                    password: _newPasswordController.text);
                            }
                          },
                          child: const Text('Change'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
