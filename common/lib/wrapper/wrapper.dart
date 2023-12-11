import 'package:coordinator/menu/main_menu.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/login_cubit/login_cubit.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:students/features/menu/main_menu.dart';
import 'package:supervisor/menu/main_menu.dart';

import '../auth/login_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, loginState) {
        switch (loginState) {
          case LoginInitial():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: primaryColor,
              content: Text("Initialized..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
          case LoginLoading():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Loading..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
          case LoginFailed():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Failed : ${loginState.message}..."),
              duration: const Duration(milliseconds: 500),
            ));
            break;
          case LoginSuccess():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Success..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
        }
        ;
        if (loginState is LoginSuccess) {
          BlocProvider.of<WrapperCubit>(context).isSignIn();
        }
        if (loginState is LoginFailed) {
          CustomAlert.error(message: loginState.message, context: context);
          BlocProvider.of<LoginCubit>(context, listen: false).reset();
        }
      },
      builder: (context, loginState) {
        return BlocConsumer<WrapperCubit, WrapperState>(
          listener: (context, state1) {
            switch (state1) {
              case WrapperInitial():
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Initialized..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case WrapperLoading():
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Check SignIn Loading..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case WrapperFailed():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Check SignIn: ${state1.message}..."),
                  duration: const Duration(milliseconds: 500),
                ));
                break;
              case CredentialExist():
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Credential Found..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case CredentialNotExist():
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Credential Not Found..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
            }
            if (state1 is WrapperFailed) {
              CustomAlert.error(message: state1.message, context: context);
              BlocProvider.of<WrapperCubit>(context, listen: false).reset();
            }
          },
          builder: (context, state) {
            if (state is WrapperLoading) {
              return const Scaffold(
                body: CustomLoading(),
              );
            }

            if (state is CredentialExist) {
              final UserCredential credential = state.credential;
              switch (credential.role) {
                case 'SUPERVISOR' || 'DPK':
                  return const MainMenuSupervisor();
                case 'ER':
                  return const MainMenuCoordinator();
                case 'STUDENT':
                  return const StudentMainMenu();
                default:
                  return const LoginPage();
              }
            }
            return const LoginPage();
          },
        );
      },
    );
  }
}
