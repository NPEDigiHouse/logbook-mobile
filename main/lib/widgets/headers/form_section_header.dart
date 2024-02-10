import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormSectionHeader extends StatelessWidget {
  final String label;
  final String pathPrefix;
  final double padding;
  final VoidCallback? onTap;
  final bool? isVerified;
  const FormSectionHeader(
      {super.key,
      required this.label,
      required this.pathPrefix,
      this.onTap,
      this.isVerified,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        SpacingRow(
          onlyPading: true,
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          horizontalPadding: padding,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                AssetPath.getIcon(pathPrefix),
                color: primaryColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isVerified ?? false) ...[
              SizedBox(
                width: 4,
              ),
              const Icon(
                Icons.verified_rounded,
                color: primaryColor,
                size: 16,
              ),
            ],
            const Spacer(),
            if (onTap != null)
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF29C5F6).withOpacity(.2),
                    ),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  iconSize: 14,
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.add_rounded,
                    color: primaryColor,
                    size: 16,
                  ),
                ),
              )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
