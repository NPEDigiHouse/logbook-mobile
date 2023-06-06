import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/students/menu/global/global_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/unit/unit_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/custom_navigation_bar.dart';

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
  }
}
