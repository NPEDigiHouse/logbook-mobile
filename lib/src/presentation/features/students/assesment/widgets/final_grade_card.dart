import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/student_final_grade_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class FinalGradeCard extends StatelessWidget {
  const FinalGradeCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWellContainer(
          onTap: () => context.navigateTo(StudentFinalGrade()),
          color: Color(0xFF219ABF),
          radius: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxWidth / 2.6,
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: SvgPicture.asset(
                      AssetPath.getVector(
                        'layer1.svg',
                      ),
                      height: constraints.maxWidth / 2.6,
                      fit: BoxFit.fitHeight,
                      color: Color(0xFF29C5F6).withOpacity(.54),
                    ),
                  ),
                  Positioned(
                    child: SvgPicture.asset(
                      AssetPath.getVector(
                        'layer2.svg',
                      ),
                      height: constraints.maxWidth / 2.6,
                      fit: BoxFit.fitHeight,
                      color: Color(0xFF29C5F6).withOpacity(.5),
                    ),
                  ),
                  Positioned(
                    child: SvgPicture.asset(
                      AssetPath.getVector(
                        'layer3.svg',
                      ),
                      height: constraints.maxWidth / 2.6,
                      fit: BoxFit.fitHeight,
                      color: Color(0xFF29C5F6),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: scaffoldBackgroundColor,
                                  ),
                                  child: SvgPicture.asset(
                                    AssetPath.getIcon('icon_final_grade.svg'),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Final Grade',
                                  style: textTheme.titleMedium?.copyWith(
                                      color: scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    'Lorem ipsum dolor sit amet consectetur.',
                                    maxLines: 2,
                                    style: textTheme.bodySmall?.copyWith(
                                      height: 1.2,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SleekCircularSlider(
                              innerWidget: (e) => Center(
                                child: Container(
                                  margin: EdgeInsets.all(14),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7EC5DB),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      e.toStringAsFixed(1),
                                      style: textTheme.titleMedium?.copyWith(
                                        color: scaffoldBackgroundColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              appearance: CircularSliderAppearance(
                                customWidths: CustomSliderWidths(
                                  progressBarWidth: 10,
                                  trackWidth: 8,
                                  handlerSize: 2,
                                  shadowWidth: 0,
                                ),
                                // spinnerMode: true,
                                customColors: CustomSliderColors(
                                  progressBarColors: [
                                    Color(0xFF2AC5F7),
                                    Color(0xFFA2E8FF),
                                    Color(0xFF89E1FD),
                                  ],
                                  trackColor: Color(0xFFADDAE7),
                                ),
                              ),
                              min: 0,
                              max: 100,
                              initialValue: 98.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}