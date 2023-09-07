import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/list_mini_cex_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/list_personal_behavior_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/list_scientific_assignment_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/widgets/final_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssesmentStudentHomePage extends StatelessWidget {
  final String studentId;
  final UserCredential credential;

  const AssesmentStudentHomePage({
    super.key,
    required this.credential,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assesment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SpacingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          horizontalPadding: 16,
          spacing: 12,
          children: [
            DepartmentHeader(
              unitName: 'Department Name',
            ),
            SizedBox(
              height: 12,
            ),
            if (credential.badges!
                    .indexWhere((element) => element.name == 'CEU') !=
                -1) ...[
              FinalGradeCard(),
            ],
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_test.svg',
                  title: 'Mini Cex',
                  desc: 'Mini Clinical Evaluation Exercise',
                  onTap: () => context.navigateTo(
                      ListMiniCexPage(unitName: '', studentId: studentId)),
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_scientific_assignment.svg',
                  title: 'Scientific Assignment Grade',
                  onTap: () => context.navigateTo(ListScientificAssignmentPage(
                    unitName: '',
                    studentId: studentId,
                  )),
                  desc: 'Scientific assessment or assignment',
                ),
              ],
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_personal_behavior.svg',
                  title: 'Personal Behavior Grade',
                  desc: 'Assessment given to personal behavior or behavior',
                  onTap: () => context.navigateTo(ListPersonalBehaviorPage(
                      unitName: '', studentId: studentId)),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AssementMenuCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final String desc;
  const AssementMenuCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWellContainer(
        onTap: onTap,
        radius: 12,
        padding: EdgeInsets.all(20),
        color: scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            color: Color(0xFF374151).withOpacity(.15),
          )
        ],
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: SvgPicture.asset(
                  AssetPath.getIcon(
                    iconPath,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                maxLines: 2,
                style: textTheme.bodyMedium?.copyWith(
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
