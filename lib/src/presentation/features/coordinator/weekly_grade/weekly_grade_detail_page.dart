import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/dummy_models.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/weekly_grade_score_dialog.dart';
import 'package:elogbook/src/presentation/widgets/cards/weekly_grade_card.dart';

class WeeklyGradeDetailPage extends StatefulWidget {
  final StudentWeeklyGrade student;

  const WeeklyGradeDetailPage({super.key, required this.student});

  @override
  State<WeeklyGradeDetailPage> createState() => _WeeklyGradeDetailPageState();
}

class _WeeklyGradeDetailPageState extends State<WeeklyGradeDetailPage> {
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: GestureDetector(
                  onTap: () => context.back(),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.student.supervisor,
                      style: const TextStyle(
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
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 56,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
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
              const SizedBox(height: 8),
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (_, i) {
                  final grades = widget.student.grades;

                  return WeeklyGradeCard(
                    date: grades[i].date,
                    place: grades[i].place,
                    week: grades[i].week,
                    score: grades[i].score,
                    onTap: () => showDialog(
                      context: context,
                      barrierLabel: '',
                      barrierDismissible: false,
                      builder: (_) => WeeklyGradeScoreDialog(
                        week: grades[i].week,
                        score: grades[i].score,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: widget.student.grades.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
