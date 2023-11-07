import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/logout_cubit/logout_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:elogbook/src/presentation/features/supervisor/history/history_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/in_out_reporting/in_out_reporting_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/menu/unit/supervisor_menu_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';

class MainMenuSupervisor extends StatefulWidget {
  const MainMenuSupervisor({super.key});

  @override
  State<MainMenuSupervisor> createState() => _MainMenuSupervisorState();
}

class _MainMenuSupervisorState extends State<MainMenuSupervisor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<UserCubit>(context)..getUserCredential());
  }

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listPage(UserCredential credential) => [
          SupervisorMenuPage(
            credential: credential,
          ),
          // TaskPage(),
          if (credential.badges!.indexWhere((e) => e.name == 'HEAD_DIV') != -1)
            InOutReportingPage(),
          ListResidentPage(),
          SupervisorHistoryPage(
            isKabag:
                credential.badges!.indexWhere((e) => e.name == 'HEAD_DIV') !=
                    -1,
            isCeu: credential.badges!.indexWhere((e) => e.name == 'CEU') != -1,
            departmentName: credential.supervisor?.units ?? [],
            supervisorId: credential.supervisor?.supervisorId ?? '',
          ),
          // SizedBox(),
          ProfilePage(
            credential: credential,
          ),
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
                    body: _listPage(s.userCredential!)[value],
                    bottomNavigationBar: CustomNavigationBar(
                      listIconPath: [
                        "home_icon.svg",
                        if (s.userCredential!.badges!
                                .indexWhere((e) => e.name == 'HEAD_DIV') !=
                            -1)
                          'wifi_protected_setup_rounded.svg',
                        "icon_residents.svg",
                        "icon_supervisor_history.svg",
                        "icon_user.svg"
                      ],
                      listTitle: [
                        'Tasks',
                        if (s.userCredential!.badges!
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
