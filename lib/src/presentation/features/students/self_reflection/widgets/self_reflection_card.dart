import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/self_reflection_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentSelfReflectionCard extends StatelessWidget {
  const StudentSelfReflectionCard({
    super.key,
    required this.model,
  });

  final SelfReflectionData model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.navigateTo(DetailSelfReflectionPage(
          model: model,
        )),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          'Self Reflections',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (model.verificationStatus == 'VERIFIED')
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: primaryColor,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.content ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: secondaryTextColor),
                    ),
                    const SizedBox(height: 8),
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
