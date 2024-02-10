// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:common/features/auth/login_page.dart';
import 'package:common/features/history/history_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:main/blocs/logout_cubit/logout_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_navigation_bar.dart';

import '../history/history_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          const HistoryView(
            role: UserHistoryRole.coordinator,
          ),
          const CoordinatorProfilePage(),
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
                if (s.userCredential != null) {
                  return Scaffold(
                    body: IndexedStack(
                      index: value,
                      children: _listPage(s.userCredential!),
                    ),
                    bottomNavigationBar: CustomNavigationBar(
                      listIconPath: const [
                        "icon_task.svg",
                        "icon_supervisor_history.svg",
                        "icon_user.svg"
                      ],
                      listTitle: const ['Tasks', 'History', 'Profile'],
                      selectedIndex: _selectedIndex,
                      value: value,
                    ),
                  );
                }
                return const Scaffold(
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
