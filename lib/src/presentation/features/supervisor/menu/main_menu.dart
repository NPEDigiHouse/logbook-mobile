import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:elogbook/src/presentation/features/supervisor/history/history_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/in_out_reporting/in_out_reporting_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/menu/unit/supervisor_menu_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/tasks/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';

class MainMenuSupervisor extends StatefulWidget {
  final UserCredential credential;
  const MainMenuSupervisor({super.key, required this.credential});

  @override
  State<MainMenuSupervisor> createState() => _MainMenuSupervisorState();
}

class _MainMenuSupervisorState extends State<MainMenuSupervisor> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = [
      SupervisorMenuPage(
        credential: widget.credential,
      ),
      // TaskPage(),
      if (widget.credential.badges!.indexWhere((e) => e.name == 'HEAD_DIV') !=
          -1)
        InOutReportingPage(),
      ListResidentPage(),
      const HistoryPage(),
      ProfilePage(
        credential: widget.credential,
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
                  "home_icon.svg",
                  if (widget.credential.badges!
                          .indexWhere((e) => e.name == 'HEAD_DIV') !=
                      -1)
                    'wifi_protected_setup_rounded.svg',
                  "icon_residents.svg",
                  "icon_supervisor_history.svg",
                  "icon_user.svg"
                ],
                listTitle: [
                  'Tasks',
                  if (widget.credential.badges!
                          .indexWhere((e) => e.name == 'HEAD_DIV') !=
                      -1)
                    'In-Out',
                  'Students',
                  'History',
                  'Profile'
                ],
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
