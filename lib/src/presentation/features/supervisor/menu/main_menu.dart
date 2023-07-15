import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:elogbook/src/presentation/features/supervisor/history/history_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/tasks/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';

class MainMenuSupervisor extends StatefulWidget {
  const MainMenuSupervisor({super.key});

  @override
  State<MainMenuSupervisor> createState() => _MainMenuSupervisorState();
}

class _MainMenuSupervisorState extends State<MainMenuSupervisor> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final _listPage = [
    const TaskPage(),
    const HistoryPage(),
    const ListResidentPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  "icon_history.svg",
                  "icon_residents.svg",
                  "icon_user.svg"
                ],
                listTitle: ['Tasks', 'History', 'Students', 'Profile'],
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
