import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class ReportExpansionTile extends StatelessWidget {
  final IconData leadingIcon;
  final Color leadingColor;
  final String title;
  final String subtitle;
  final bool isVerified;
  final List<Widget> children;

  const ReportExpansionTile({
    super.key,
    required this.leadingIcon,
    required this.leadingColor,
    required this.title,
    required this.subtitle,
    this.isVerified = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: primaryTextColor,
          collapsedIconColor: primaryTextColor,
          tilePadding: const EdgeInsets.only(
            left: 6,
            right: 10,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: leadingColor.withOpacity(.2),
            ),
            child: Icon(
              leadingIcon,
              color: leadingColor,
              size: 20,
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              if (isVerified)
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: primaryColor,
                ),
            ],
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}
