import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormSectionHeader extends StatelessWidget {
  final String label;
  final String pathPrefix;
  final double padding;
  final VoidCallback? onTap;
  const FormSectionHeader(
      {super.key,
      required this.label,
      required this.pathPrefix,
      this.onTap,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
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
            SizedBox(
              width: 8,
            ),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            if (onTap != null)
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF29C5F6).withOpacity(.2),
                    ),
                  ),
                  padding: new EdgeInsets.all(0.0),
                  iconSize: 14,
                  onPressed: onTap,
                  icon: Icon(
                    Icons.add_rounded,
                    color: primaryColor,
                    size: 16,
                  ),
                ),
              )
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
