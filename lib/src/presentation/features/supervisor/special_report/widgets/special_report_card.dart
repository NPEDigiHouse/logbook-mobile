import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_response.dart';
import 'package:elogbook/src/presentation/features/supervisor/special_report/verify_special_report_page.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';

class SupervisorSpecialReportCard extends StatelessWidget {
  final String studentId;
  final int index;
  final ListProblemConsultation data;
  const SupervisorSpecialReportCard(
      {super.key,
      required this.index,
      required this.data,
      required this.studentId});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      radius: 12,
      onTap: () {
        context.navigateTo(VerifySpecialReportPage(
          problemConsultation: data,
          studentId: studentId,
        ));
      },
      color: Colors.white,
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
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Problem Consultation #$index',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              if (data.verificationStatus == 'VERIFIED')
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: primaryColor,
                ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ItemDivider(),
          SizedBox(
            height: 8,
          ),
          Text(
            'Encountered Problems',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            data.content!.trim(),
            style: textTheme.bodyMedium?.copyWith(height: 1.2),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Provided Solutions',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          SizedBox(
            height: 4,
          ),
          (data.solution != null)
              ? Text(
                  data.solution!.trim(),
                  style: textTheme.bodyMedium?.copyWith(height: 1.2),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: onFormDisableColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'no solution provided yet',
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
