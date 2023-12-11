import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Widget> getHeadSection(
    {required ValueListenable<String> title,
    required String subtitle,
    required SupervisorStudent student}) {
  return [
    SliverAppBar(
      pinned: true,
      shadowColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: primaryColor,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: scaffoldBackgroundColor,
      ),
      iconTheme: const IconThemeData(
        color: scaffoldBackgroundColor,
      ),
      title: ValueListenableBuilder(
        valueListenable: title,
        builder: (context, val, _) {
          return Text(val);
        },
      ),
    ),
    SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(color: primaryColor),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: student.profileImage == null
                    ? DecorationImage(
                        image: AssetImage(
                          AssetPath.getImage('profile_default.png'),
                        ),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: MemoryImage(
                          student.profileImage!,
                        ),
                        fit: BoxFit.cover,
                      ),
                border: Border.all(
                  width: 2,
                  color: scaffoldBackgroundColor,
                ),
              ),
            ),
            Text(
              student.studentName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleLarge?.copyWith(
                color: scaffoldBackgroundColor,
              ),
            ),
            Text(
              student.studentId ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ),
    SliverAppBar(
      pinned: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: primaryColor,
      ),
      elevation: 1,
      shadowColor: Colors.black12,
      leading: const SizedBox(),
      title: Text(subtitle),
    ),
    const SliverToBoxAdapter(
      child: SizedBox(
        height: 16,
      ),
    ),
    const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(),
    ),
  ];
}
