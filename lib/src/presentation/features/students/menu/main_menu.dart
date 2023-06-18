import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/features/common/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/students/menu/global/global_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/unit/unit_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ValueNotifier<int> _selectedIndex = new ValueNotifier(0);

  final _listPage = [
    UnitActivityPage(),
    GlobalActivityPage(),
    HistoryPage(),
    Container(),
  ];

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is LogoutSuccess) {
        print("caller");
        context.replace(LoginPage());
      }
    }, builder: (context, state) {
      return ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, val, _) {
          return Scaffold(
            body: _listPage[val],
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              val: val,
            ),
          );
        },
      );
    });
  }
}
