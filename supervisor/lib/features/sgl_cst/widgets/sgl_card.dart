import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:supervisor/features/sgl_cst/sgl_single_page.dart';

import '../supervisor_sgl_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SglOnListCard extends StatelessWidget {
  final SglCstOnList sglCst;
  final String userId;
  final bool isCeu;

  const SglOnListCard(
      {super.key,
      required this.sglCst,
      required this.isCeu,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.navigateTo(
            SglSinglePage(
              id: sglCst.id ?? "",
              isCeu: isCeu,
              userId: userId,
            ),
          );
          // context.navigateTo(SupervisorSglDetailPage(
          //   studentId: sglCst.studentId!,
          //   userId: userId,
          //   isCeu: isCeu,
          //   unitName: sglCst.activeDepartmentName,
          //   studentName: sglCst.studentName ?? '...',
          // ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 68,
                  height: 68,
                  color: primaryColor.withOpacity(.1),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPath.getIcon('diversity_3_rounded.svg'),
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
                      'Small Group Learning',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: onFormDisableColor,
                        height: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          Utils.datetimeToString(sglCst.latest!,
                              format: 'EEE, dd MMM'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            height: 1.2,
                          ),
                        ),
                        if (sglCst.verificationStatus == 'VERIFIED')
                          const Icon(
                            Icons.verified_rounded,
                            color: primaryColor,
                            size: 16,
                          )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sglCst.studentName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        height: 1,
                        color: secondaryColor,
                      ),
                    ),
                    if (isCeu) ...[
                      const SizedBox(
                        height: 4,
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
                            TextSpan(
                              text: sglCst.activeDepartmentName ??
                                  'No Active Department',
                            ),
                          ],
                        ),
                      ),
                    ],
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
