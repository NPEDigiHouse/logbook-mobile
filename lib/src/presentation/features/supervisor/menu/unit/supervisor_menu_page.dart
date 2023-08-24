import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_row.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/list_menu_column.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/menu_switch.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/list_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/list_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/list_self_reflection_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/students_task/list_student_menu_page.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorMenuPage extends StatefulWidget {
  final UserCredential credential;

  const SupervisorMenuPage({super.key, required this.credential});

  @override
  State<SupervisorMenuPage> createState() => _SupervisorMenuPageState();
}

class _SupervisorMenuPageState extends State<SupervisorMenuPage> {
  late final ValueNotifier<bool> _isList;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context)..getProfilePic();

    _isList = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    _isList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.credential.fullname);
    return CustomScrollView(
      slivers: <Widget>[
        const MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state.profilePic != null) {
                          return CircleAvatar(
                            radius: 25,
                            foregroundImage: MemoryImage(state.profilePic!),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 25,
                            foregroundImage: AssetImage(
                              AssetPath.getImage('profile_default.png'),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.credential.fullname ?? 'Unnamed',
                          style: textTheme.titleSmall?.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(children: [
                          Badge(
                            label: Text('Supervisor'),
                            backgroundColor: primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          ...widget.credential.badges!
                              .map(
                                (e) => Row(
                                  children: [
                                    Badge(
                                      label: Text(e.name!),
                                      backgroundColor: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                              )
                              .toList()
                        ])
                      ],
                    ))
                  ],
                ),
                const SizedBox(height: 12),
                Divider(),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return MenuSwitch(
                      value: isList,
                      onToggle: (value) => _isList.value = value,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: _isList,
                  builder: (context, isList, child) {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        reverseDuration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isList ? buildItemList() : buildItemGrid());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildItemGrid() {
    return Column(
      key: const ValueKey(1),
      children: <Widget>[
        GridMenuRow(
            itemColor: primaryColor,
            menus: listSupervisorMenu.sublist(0, 4),
            onTaps: [
              () => context.navigateTo(ListClinicalRecord()),
              () => context.navigateTo(ListScientificSessionPage()),
              () => context.navigateTo(ListSelfReflectionsPage()),
              ...listSupervisorMenu.sublist(3, 4).map((e) {
                return () => context.navigateTo(
                      ListStudentMenuPage(
                        title: e.labels,
                      ),
                    );
              }).toList()
            ]),
        const SizedBox(height: 12),
        GridMenuRow(
            itemColor: variant2Color,
            menus: listSupervisorMenu.sublist(4, 8),
            onTaps: listSupervisorMenu.sublist(4, 8).map((e) {
              return () => context.navigateTo(
                    ListStudentMenuPage(
                      title: e.labels,
                    ),
                  );
            }).toList()),
        const SizedBox(height: 12),
        GridMenuRow(
            length: 1,
            itemColor: variant1Color,
            menus: listSupervisorMenu.sublist(8, listSupervisorMenu.length),
            onTaps: listSupervisorMenu
                .sublist(8, listSupervisorMenu.length)
                .map((e) {
              return () => context.navigateTo(
                    ListStudentMenuPage(
                      title: e.labels,
                    ),
                  );
            }).toList()),
      ],
    );
  }

  Column buildItemList() {
    return Column(
      key: const ValueKey(2),
      children: <Widget>[
        ListMenuColumn(
          itemColor: primaryColor,
          menus: listSupervisorMenu.sublist(0, 4),
          onTaps: [],
        ),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
          itemColor: variant2Color,
          menus: listSupervisorMenu.sublist(4, 8),
          onTaps: [],
        ),
        const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        ),
        ListMenuColumn(
          length: 1,
          itemColor: variant1Color,
          menus: listSupervisorMenu.sublist(8, listSupervisorMenu.length),
          onTaps: [],
        ),
      ],
    );
  }
}
