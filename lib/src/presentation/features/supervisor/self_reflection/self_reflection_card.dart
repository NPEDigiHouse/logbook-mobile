import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_model.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_student_page.dart';
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
          SelfReflectionStudentPage(
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
                      selfReflection.studentId ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          selfReflection.studentName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
