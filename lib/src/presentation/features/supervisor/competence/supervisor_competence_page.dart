import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/list_student_cases_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/list_student_skills_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorCompetenceHomePage extends StatefulWidget {
  const SupervisorCompetenceHomePage({
    super.key,
  });

  @override
  State<SupervisorCompetenceHomePage> createState() =>
      _SupervisorCompetenceHomePageState();
}

class _SupervisorCompetenceHomePageState
    extends State<SupervisorCompetenceHomePage> {
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Competency"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SpacingColumn(
            onlyPading: true,
            horizontalPadding: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CompetenceCard(
                          onTap: () =>
                              context.navigateTo(ListStudentCasesPage()),
                          title: 'Cases',
                          desc: 'List Acquired Case',
                          iconData: Icons.cases_rounded,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: CompetenceCard(
                          onTap: () =>
                              context.navigateTo(ListStudentTasksPage()),
                          title: 'Skills',
                          desc: 'List Diagnosis Skill',
                          iconData: Icons.back_hand_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompetenceCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData iconData;
  final VoidCallback onTap;
  const CompetenceCard({
    super.key,
    required this.desc,
    required this.onTap,
    required this.iconData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bc) {
      return InkWellContainer(
        radius: 12,
        onTap: onTap,
        color: scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            spreadRadius: 0,
            color: Color(0xFF374151).withOpacity(
              .15,
            ),
          )
        ],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: bc.maxWidth,
            height: 132,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  width: bc.maxWidth,
                  height: bc.maxWidth * 60 / 144,
                  child: SvgPicture.asset(
                    AssetPath.getVector('bottom_competence.svg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  width: bc.maxWidth,
                  height: bc.maxWidth * 44 / 144,
                  child: SvgPicture.asset(
                    AssetPath.getVector('top_competence.svg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: bc.maxWidth,
                  child: SpacingColumn(
                    onlyPading: true,
                    horizontalPadding: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                  blurRadius: 6,
                                  color: Color(0xFFD4D4D4).withOpacity(.25)),
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                  blurRadius: 24,
                                  color: Color(0xFFD4D4D4).withOpacity(.25)),
                            ]),
                        child: Icon(
                          iconData,
                          color: primaryColor,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        desc,
                        style: textTheme.bodySmall?.copyWith(
                          height: 1,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
