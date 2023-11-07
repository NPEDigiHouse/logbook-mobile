import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:elogbook/src/presentation/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/features/coordinator/menu/main_menu.dart';
import 'package:elogbook/src/presentation/features/students/menu/main_menu.dart';
import 'package:elogbook/src/presentation/features/supervisor/menu/main_menu.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: primaryColor,
              content: Text("Initialized..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
          case LoginLoading():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Loading..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
          case LoginFailed():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Failed : ${loginState.message}..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
          case LoginSuccess():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: primaryColor,
              content: Text("Login Success..."),
              duration: Duration(milliseconds: 500),
            ));
            break;
        }
        ;
        if (loginState is LoginSuccess) {
          BlocProvider.of<WrapperCubit>(context)..isSignIn();
        }
        if (loginState is LoginFailed) {
          CustomAlert.error(message: loginState.message, context: context);
          BlocProvider.of<LoginCubit>(context, listen: false)..reset();
        }
      },
      builder: (context, loginState) {
        return BlocConsumer<WrapperCubit, WrapperState>(
          listener: (context, state1) {
            switch (state1) {
              case WrapperInitial():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Initialized..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case WrapperLoading():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Check SignIn Loading..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case WrapperFailed():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Check SignIn: ${state1.message}..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case CredentialExist():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Credential Found..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
              case CredentialNotExist():
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: primaryColor,
                  content: Text("Credential Not Found..."),
                  duration: Duration(milliseconds: 500),
                ));
                break;
            }
            if (state1 is WrapperFailed) {
              CustomAlert.error(message: state1.message, context: context);
              BlocProvider.of<WrapperCubit>(context, listen: false)..reset();
            }
          },
          builder: (context, state) {
            if (state is WrapperLoading) {
              return Scaffold(
                body: CustomLoading(),
              );
            }

            if (state is CredentialExist) {
              final UserCredential credential = state.credential;
              print(credential.role);
              switch (credential.role) {
                case 'SUPERVISOR' || 'DPK':
                  return MainMenuSupervisor();
                case 'ER':
                  return MainMenuCoordinator();
                case 'STUDENT':
                  return MainMenu();
                default:
                  return LoginPage();
              }
            }
            return LoginPage();
          },
        );
      },
    );
  }
}
