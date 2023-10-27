import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:flutter/material.dart';

class StudentDepartmentHeader extends StatelessWidget {
  final String? unitName;
  final String studentName;
  final String? studentId;
  final String? supervisorName;
  const StudentDepartmentHeader(
      {super.key,
      this.unitName,
      required this.studentName,
      this.supervisorName,
      this.studentId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: primaryTextColor,
          collapsedIconColor: primaryTextColor,
          tilePadding: EdgeInsets.only(
            left: 6,
            right: 10,
          ),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          title: FormSectionHeader(
              label: 'Student Data',
              pathPrefix: 'person_filled.svg',
              padding: 0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fullname',
                  style:
                      textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
                ),
                Text(
                  studentName,
                  style: textTheme.titleMedium?.copyWith(
                    color: primaryTextColor,
                    height: 1,
                  ),
                ),
                if (studentId != null) ...[
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'ID',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: secondaryTextColor),
                  ),
                  Text(
                    studentId!,
                    style: textTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                      height: 1,
                    ),
                  ),
                ],
                if (supervisorName != null) ...[
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Supervisor',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: secondaryTextColor),
                  ),
                  Text(
                    supervisorName!,
                    style: textTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                      height: 1,
                    ),
                  ),
                ],
                if (unitName != null) ...[
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Department',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: secondaryTextColor),
                  ),
                  Text(
                    unitName!,
                    style: textTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                      height: 1,
                    ),
                  ),
                ],
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
