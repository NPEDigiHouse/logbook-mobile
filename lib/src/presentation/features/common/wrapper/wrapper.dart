import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
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
  void initState() {
    super.initState();
    Future.microtask(() {
      print("fall");
      BlocProvider.of<AuthCubit>(context)
        ..reset()
        ..isSignIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state1) {
        if (state1 is LoginSuccess) {
          BlocProvider.of<AuthCubit>(context)..isSignIn();
        }
        if (state1 is Failed) {
          CustomAlert.error(message: state1.message, context: context);
          state1 = Initial();
        }
      },
      builder: (context, state) {
        if (state is SuccessDeleteAccount) {
          return LoginPage();
        }

        if (state is CredentialNotExist) {
          return LoginPage();
        }

        if (state is CredentialExist) {
          final UserCredential credential = state.credential;
          switch (credential.role) {
            case 'SUPERVISOR' || 'DPK':
              return MainMenuSupervisor();
            case 'ER':
              return MainMenuCoordinator();
            case 'STUDENT':
              return MainMenu();
            default:
          }
        }

        return Scaffold(
          body: CustomLoading(),
        );
      },
    );
  }
}
