import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class SglCstAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBtnPressed;
  const SglCstAppBar(
      {super.key, required this.title, required this.onBtnPressed});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      title: Text(
        title,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: scaffoldBackgroundColor,
        ),
        onPressed: () => context.back(),
      ),
      backgroundColor: primaryColor,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: scaffoldBackgroundColor,
        fontWeight: FontWeight.bold,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    side: BorderSide(
                      color: backgroundColor,
                      width: 1,
                    ),
                    backgroundColor: Colors.white.withOpacity(.2),
                  ),
                  onPressed: onBtnPressed,
                  icon: Icon(
                    Icons.add_rounded,
                  ),
                  label: Text('Add New Data'),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
