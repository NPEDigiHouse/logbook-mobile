import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/delete_account_cubit/delete_account_cubit.dart';
import 'package:elogbook/src/presentation/blocs/logout_cubit/logout_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/unit/unit_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({
    super.key,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
          DepartmentActivityPage(
            credential: credential,
          ),
          // const GlobalActivityPage(),
          HistoryPage(),
          ProfilePage(
            credential: credential,
          ),
        ];
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, deleteStatte) {
      if (deleteStatte is DeleteSuccess) {
        context.replace(const LoginPage());
      }
    }, builder: (context, logoutState) {
      return BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, logoutState) {
          if (logoutState is LogoutSuccess) {
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
              }, builder: (context, s) {
                if (s.initState == RequestState.data &&
                    s.userCredential != null) {
                  return Scaffold(
                    body: IndexedStack(
                      index: value,
                      children: _listPage(s.userCredential!),
                    ),
                    bottomNavigationBar: CustomNavigationBar(
                      listIconPath: const [
                        "icon_unit.svg",
                        "icon_history.svg",
                        "icon_user.svg"
                      ],
                      listTitle: const [
                        "Department\nActivity",
                        "History",
                        "Profile"
                      ],
                      selectedIndex: _selectedIndex,
                      value: value,
                    ),
                  );
                } else if (s.initState == RequestState.loading) {
                  return Scaffold(
                    body: CustomLoading(),
                  );
                } else {
                  return Scaffold(body: SizedBox.shrink());
                }
              });
            },
          );
        },
      );
    });
  }
}
