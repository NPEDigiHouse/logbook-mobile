import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/self_reflection/self_reflection_model.dart';

import 'self_reflection_student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelfReflectionCard extends StatelessWidget {
  final SelfReflectionModel selfReflection;
  const SelfReflectionCard({super.key, required this.selfReflection});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.navigateTo(
          SupervisorSelfReflectionStudentPage(
            studentId: selfReflection.studentId!,
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
                      AssetPath.getIcon('emoji_objects_rounded.svg'),
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
                      'Self Reflection',
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
                          Utils.datetimeToString(selfReflection.latest!,
                              format: 'EEE, dd MMM'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            height: 1.2,
                          ),
                        ),
                        if (selfReflection.verificationStatus == 'VERIFIED')
                          const Icon(
                            Icons.verified_rounded,
                            color: primaryColor,
                            size: 16,
                          )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          selfReflection.studentName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1,
                            color: secondaryColor,
                          ),
                        ),
                      ],
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
                          const TextSpan(
                            text: 'Department:\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: selfReflection.unitName),
                        ],
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
                            text: 'Latest:\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                              text: Utils.datetimeToString(
                            selfReflection.latest!,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
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
