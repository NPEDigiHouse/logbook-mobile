import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
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
          DepartmentActivityPage(
            credential: credential,
          ),
          // const GlobalActivityPage(),
          HistoryPage(),
          ProfilePage(
            credential: credential,
          ),
        ];
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess || state is SuccessDeleteAccount) {
          context.replace(const LoginPage());
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (context, value, _) {
            return BlocBuilder<UserCubit, UserState>(builder: (context, s) {
              if (s.userCredential != null)
                return Scaffold(
                  body: IndexedStack(
                    index: value,
                    children: _listPage(s.userCredential!),
                  ),
                  bottomNavigationBar: CustomNavigationBar(
                    listIconPath: const [
                      "icon_unit.svg",
                      // "icon_globe.svg",
                      "icon_history.svg",
                      "icon_user.svg"
                    ],
                    listTitle: const [
                      "Department\nActivity",
                      // "Global\nActivity",
                      "History",
                      "Profile"
                    ],
                    selectedIndex: _selectedIndex,
                    value: value,
                  ),
                );
              return Scaffold(
                body: CustomLoading(),
              );
            });
          },
        );
      },
    );
  }
}
