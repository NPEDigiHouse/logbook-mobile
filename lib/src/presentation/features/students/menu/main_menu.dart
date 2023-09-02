import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/global/global_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/profile_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/unit/unit_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';

class MainMenu extends StatefulWidget {
  final UserCredential credential;

  const MainMenu({
    super.key,
    required this.credential,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = [
      UnitActivityPage(
        credential: widget.credential,
      ),
      const GlobalActivityPage(),
      HistoryPage(),
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
                listIconPath: const [
                  "icon_unit.svg",
                  "icon_globe.svg",
                  "icon_history.svg",
                  "icon_user.svg"
                ],
                listTitle: const [
                  "Unit\nActivity",
                  "Global\nActivity",
                  "History",
                  "Profile"
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
