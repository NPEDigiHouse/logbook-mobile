import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/dummy_models.dart';

class CheckReportBottomSheet extends StatelessWidget {
  final String title;
  final int iconQuarterTurns;
  final StudentCheckReport student;

  const CheckReportBottomSheet({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFFD1D5DB),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                RotatedBox(
                  quarterTurns: iconQuarterTurns,
                  child: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Send it on: ${student.date}',
              style: textTheme.bodySmall?.copyWith(
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 28,
                  foregroundImage: AssetImage(
                    AssetPath.getImage('profile_default.png'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.id,
                        style: textTheme.bodySmall?.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              minLines: 5,
              maxLines: 5,
              decoration: const InputDecoration(
                label: Text('Additional Notes'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // do something
                  context.back();
                },
                icon: const Icon(
                  Icons.verified_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Verify',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
