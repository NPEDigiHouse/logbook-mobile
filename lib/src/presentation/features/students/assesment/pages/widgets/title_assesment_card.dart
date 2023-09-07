import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class TitleAssesmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleAssesmentCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Exam Title",
            style: textTheme.titleMedium?.copyWith(
              color: scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "\"${title}\"",
            style: textTheme.bodyLarge?.copyWith(
              color: scaffoldBackgroundColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(.75),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${subtitle}",
                      style: textTheme.bodyMedium?.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
