import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/dummy_models.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';

class InOutReportingItem extends StatelessWidget {
  final StudentCheckReport student;
  final VoidCallback? onTap;

  const InOutReportingItem({
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
                  student.date,
                  style: textTheme.labelSmall?.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (student.isVerified)
                      const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                  ],
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
    );
  }
}
