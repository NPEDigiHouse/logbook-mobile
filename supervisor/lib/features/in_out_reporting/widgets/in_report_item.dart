import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/students/student_check_in_model.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/profile_pic_placeholder.dart';

class InReportingItem extends StatelessWidget {
  final StudentCheckInModel student;
  final VoidCallback? onTap;

  const InReportingItem({
    super.key,
    required this.student,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      color: scaffoldBackgroundColor,
      radius: 12,
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 10,
          color: Colors.black.withOpacity(.08),
        ),
      ],
      child: Row(
        children: <Widget>[
          ProfilePicPlaceholder(
              height: 56,
              name: student.fullname ?? '-',
              width: 56,
              isSmall: true),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.datetimeToString(
                      DateTime.fromMillisecondsSinceEpoch(
                          student.checkInTime! * 1000),
                      isShowTime: true),
                  style: textTheme.labelSmall?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.fullname ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  student.studentId ?? '-',
                  style: textTheme.bodySmall?.copyWith(
                    color: primaryColor,
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: textTheme.bodySmall?.copyWith(
                      color: secondaryTextColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Department:\t',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: student.unitName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
