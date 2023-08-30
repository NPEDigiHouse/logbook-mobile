import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/features/coordinator/history/history_page.dart';
import 'package:elogbook/src/presentation/features/coordinator/home/home_page.dart';
import 'package:elogbook/src/presentation/features/coordinator/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';

class MainMenuCoordinator extends StatefulWidget {
  final UserCredential credential;
  const MainMenuCoordinator({super.key, required this.credential});

  @override
  State<MainMenuCoordinator> createState() => _MainMenuCoordinatorState();
}

class _MainMenuCoordinatorState extends State<MainMenuCoordinator> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = [
      CoordinatorHomePage(
        credential: widget.credential,
      ),
      const CoordinatorHistoryPage(),
      CoordinatorProfilePage(
      ),
    ];

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.replace(const LoginPage());
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, value, _) {
            return Scaffold(
              body: _listPage[value],
              bottomNavigationBar: CustomNavigationBar(
                listIconPath: [
                  "icon_task.svg",
                  "icon_supervisor_history.svg",
                  "icon_user.svg"
                ],
                listTitle: ['Tasks', 'History', 'Profile'],
                selectedIndex: _selectedIndex,
                value: value,
              ),
            );
          },
        );
      },
    );
  }
}
