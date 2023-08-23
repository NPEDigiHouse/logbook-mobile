import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late ValueNotifier<String> _selectedMenu;

  final _menuList = [
    'All',
    'Clinical Record',
    'Scientific Session',
    'Self Reflection',
    'Daily Activity',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMenu = ValueNotifier(_menuList[0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedMenu.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Tasks',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
