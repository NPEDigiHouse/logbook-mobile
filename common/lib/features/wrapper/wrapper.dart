import 'package:coordinator/features/menu/main_menu.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/login_cubit/login_cubit.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:students/student_main.dart';
import 'package:supervisor/features/menu/main_menu.dart';

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
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<WrapperCubit, WrapperState>(
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
