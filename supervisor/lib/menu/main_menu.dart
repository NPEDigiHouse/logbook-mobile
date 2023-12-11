import 'package:common/auth/login_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/logout_cubit/logout_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_navigation_bar.dart';

import '../history/history_page.dart';
import '../in_out_reporting/in_out_reporting_page.dart';
import 'unit/supervisor_menu_page.dart';
import '../profile/profile_page.dart';
import '../list_resident/list_resident_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  List<Widget> _listPage(UserCredential credential) => [
        SupervisorMenuPage(
          credential: credential,
        ),
        // TaskPage(),
        if (credential.badges!.indexWhere((e) => e.name == 'HEAD_DIV') != -1)
          const InOutReportingPage(),
        const ListResidentPage(),
        SupervisorHistoryPage(
          isKabag:
              credential.badges!.indexWhere((e) => e.name == 'HEAD_DIV') != -1,
          isCeu: credential.badges!.indexWhere((e) => e.name == 'CEU') != -1,
          departmentName: credential.supervisor?.units ?? [],
          supervisorId: credential.supervisor?.supervisorId ?? '',
        ),
        // SizedBox(),
        ProfilePage(
          credential: credential,
        ),
      ];

  @override
  Widget build(BuildContext context) {
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
            return BlocConsumer<UserCubit, UserState>(
              listener: (context, ss) {
                if (ss.initState == RequestState.error) {
                  CustomAlert.error(
                      message: "Failed Load Credential", context: context);
                }
              },
              builder: (context, s) {
                if (s.userCredential != null) {
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
