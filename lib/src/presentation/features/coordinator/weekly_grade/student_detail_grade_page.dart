import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/dummy_models.dart';

class StudentDetailGradePage extends StatefulWidget {
  final StudentWeeklyGrade student;

  const StudentDetailGradePage({super.key, required this.student});

  @override
  State<StudentDetailGradePage> createState() => _StudentDetailGradePageState();
}

class _StudentDetailGradePageState extends State<StudentDetailGradePage> {
  late final List<String> _menuList;
  late final ValueNotifier<String> _selectedMenu;

  @override
  void initState() {
    _menuList = ['None', 'Week'];
    _selectedMenu = ValueNotifier(_menuList[0]);

    super.initState();
  }

  @override
  void dispose() {
    _selectedMenu.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppSize.getAppHeight(context),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 16,
                      color: Colors.black.withOpacity(.1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          foregroundImage: AssetImage(
                            AssetPath.getImage('profile_default.png'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.student.name,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.student.id,
                                style: const TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEFF0F9),
                      ),
                    ),
                    Text(
                      'Supervisor',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.student.supervisor,
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Weekly Grades',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Text(
                'Sort By',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 64,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _menuList.length,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                      valueListenable: _selectedMenu,
                      builder: (context, value, child) {
                        final selected = value == _menuList[index];

                        return RawChip(
                          pressElevation: 0,
                          clipBehavior: Clip.antiAlias,
                          label: Text(_menuList[index]),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          labelStyle: textTheme.bodyMedium?.copyWith(
                            color: selected ? primaryColor : primaryTextColor,
                          ),
                          side: BorderSide(
                            color: selected ? Colors.transparent : borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          selected: selected,
                          selectedColor: primaryColor.withOpacity(.2),
                          checkmarkColor: primaryColor,
                          onSelected: (_) {
                            _selectedMenu.value = _menuList[index];
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
