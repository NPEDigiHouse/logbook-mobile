import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/main_menu.dart';
import 'package:elogbook/src/presentation/features/supervisor/menu/main_menu.dart';
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
      BlocProvider.of<AuthCubit>(context).isSignIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Loading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is CredentialExist) {
          final UserCredential credential = state.credential;
          print(credential);
          return credential.role == 'SUPERVISOR'
              ? MainMenuSupervisor()
              : MainMenu();
        }
        if (state is CredentialNotExist) {
          return LoginPage();
        }
        return LoginPage();
      },
    );
  }
}
