import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About E-Logbook'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AssetPath.getVector('logo.svg'),
                  width: 60,
                  height: 60,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E-Logbook',
                      style: textTheme.titleLarge?.copyWith(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Version ${AppSettings.appVersion}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Welcome to E-Logbook, dear future doctors from the Faculty of Medicine at UMI! We are proud to present a modern solution for efficiently and accurately managing and tracking your clinical experiences. E-Logbook is the result of a collaboration between the Faculty of Medicine at UMI and CV. NPE Digital, a leading software development company that has assisted various educational institutions in delivering innovative technological solutions.',
            ),
            SizedBox(
              height: 12,
            ),
            Text('What E-Logbook Offers:'),
            Text(
                '1. Recording Clinical Experiences: Easily record your practical, observational, and clinical intervention experiences. Add important details such as diagnoses, medical procedures, and practice duration.'),
            Text(
                '2. Supervision by Instructors: We enable your supervising instructors to access and assess your logbook online. This facilitates communication and enhances your learning experience.'),
            Text(
                '3. Monitor Your Progress: Track your development in conducting clinical practices. You can view statistics and evaluations that help measure your achievements.'),
            Text(
                '4. Easy Access Anytime, Anywhere: This application is accessible via your mobile devices, allowing you to record your clinical experiences in real-time, no matter where you are.'),
            Text(
                '5. Data Security: We prioritize the security of your data. Your logbook is securely stored on our servers, so you don\'t need to worry about data loss.'),
            SizedBox(
              height: 12,
            ),
            Text(
                'Developed in collaboration with CV. NPE Digital, E-Logbook becomes an effective and reliable solution in supporting your medical education. We are committed to making your journey towards becoming a doctor easier. We believe that with this tool, you can focus on learning and self-development, while we simplify your logbook administration.'),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
