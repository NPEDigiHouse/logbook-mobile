import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';

class GlobalActivityPage extends StatefulWidget {
  const GlobalActivityPage({super.key});

  @override
  State<GlobalActivityPage> createState() => _GlobalActivityPageState();
}

class _GlobalActivityPageState extends State<GlobalActivityPage> {
  late final ValueNotifier<bool> isList;

  @override
  void initState() {
    super.initState();

    isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            ),
          ),
        ),
      ],
    );
  }
}
