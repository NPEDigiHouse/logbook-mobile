import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class StudentTestGrade extends StatelessWidget {
  const StudentTestGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Grade"),
      ).variant(),
      body: SingleChildScrollView(
        child: SpacingColumn(
          horizontalPadding: 16,
          spacing: 12,
          children: [
            SizedBox(
              height: 16,
            ),
            TitleAssesmentCard(),
            TopStatCard(),
            ...[
              TestGradeScoreCard(caseName: 'Identity and Amnesia', score: 91),
              TestGradeScoreCard(
                  caseName: 'Physical Examination and Support', score: 89),
              TestGradeScoreCard(caseName: 'Identity and Amnesia', score: 91),
              TestGradeScoreCard(
                  caseName: 'Physical Examination and Support', score: 89),
            ],
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.caseName,
    required this.score,
  });

  final String caseName;
  final int score;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                  blurRadius: 6,
                  color: Color(0xFFD4D4D4).withOpacity(.25)),
              BoxShadow(
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                  blurRadius: 24,
                  color: Color(0xFFD4D4D4).withOpacity(.25)),
            ]),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  caseName,
                  maxLines: 2,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              SizedBox(
                width: 35,
                child: Text(
                  score.toString(),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopStatCard extends StatelessWidget {
  const TopStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text(
            'Test Grade',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SectionDivider(),
          SizedBox(
            height: 12,
          ),
          SemicircularIndicator(
            contain: true,
            radius: 100,
            strokeCap: StrokeCap.round,
            color: primaryColor,
            bottomPadding: 0,
            backgroundColor: Color(0xFFB0EAFC),
            child: Column(
              children: [
                Text('1120',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  'Very Good',
                  style: textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class TitleAssesmentCard extends StatelessWidget {
  const TitleAssesmentCard({
    super.key,
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
            "Exam Case Title",
            style: textTheme.titleMedium?.copyWith(
              color: scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "\"Example Case Title Title Here\"",
            style: textTheme.bodyLarge?.copyWith(
              color: scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
