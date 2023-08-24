import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'supervisor_detail_clinical_record_page.dart';

class ClinicalRecordCard extends StatelessWidget {
  final ClinicalRecordListModel clinicalRecord;
  const ClinicalRecordCard({super.key, required this.clinicalRecord});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.navigateTo(
          SupervisorDetailClinicalRecordPage(
            id: clinicalRecord.id!,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 68,
                  height: 68,
                  color: primaryColor.withOpacity(.1),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPath.getIcon('clinical_notes_rounded.svg'),
                      color: primaryColor,
                      width: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      clinicalRecord.studentId ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          clinicalRecord.studentName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (clinicalRecord.status == 'VERIFIED')
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: primaryColor,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Date:\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                              text: ReusableFunctionHelper.datetimeToString(
                            clinicalRecord.time!,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Patient:\t',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: clinicalRecord.patientName ?? '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (clinicalRecord.attachment != null)
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: dividerColor),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.attachment_rounded,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'attachment_file.pdf',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}