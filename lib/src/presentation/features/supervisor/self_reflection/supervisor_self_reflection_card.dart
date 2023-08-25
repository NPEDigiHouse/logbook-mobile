import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorSelfReflectionCard extends StatelessWidget {
  final SelfReflectionData data;
  const SupervisorSelfReflectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data.selfReflectionId ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                  const SizedBox(height: 12),
                  Text(
                    'Content',
                    style: textTheme.bodyMedium?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  Text(
                    data.content ?? '',
                    style: textTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 4),
                  if (data.verificationStatus != 'VERIFIED')
                    Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                            onPressed: () => showDialog(
                                context: context,
                                barrierLabel: '',
                                barrierDismissible: false,
                                builder: (_) => VerifySelfReflectionDialog(
                                      id: data.selfReflectionId!,
                                    )).then((value) {}),
                            child: Text('Verify'))),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
