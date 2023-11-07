import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/logout_cubit/logout_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/history/history_page.dart';
import 'package:elogbook/src/presentation/features/coordinator/home/home_page.dart';
import 'package:elogbook/src/presentation/features/coordinator/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';

class MainMenuCoordinator extends StatefulWidget {
  const MainMenuCoordinator({
    super.key,
  });

  @override
  State<MainMenuCoordinator> createState() => _MainMenuCoordinatorState();
}

class _MainMenuCoordinatorState extends State<MainMenuCoordinator> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => BlocProvider.of<UserCubit>(context)..getUserCredential());
  }

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listPage(UserCredential credential) => [
          CoordinatorHomePage(
            credential: credential,
          ),
          const CoordinatorHistoryPage(),
          CoordinatorProfilePage(),
        ];

    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.replace(const LoginPage());
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, value, _) {
            return BlocBuilder<UserCubit, UserState>(
              builder: (context, s) {
                if (s.userCredential != null)
                  return Scaffold(
                    body: IndexedStack(
                      children: _listPage(s.userCredential!),
                      index: value,
                    ),
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
                return Scaffold(
                  body: CustomLoading(),
                );
              },
            );
          },
        );
      },
    );
  }
}
