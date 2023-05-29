import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/header/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AssesmentHomePage extends StatelessWidget {
  const AssesmentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assesment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SpacingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          horizontalPadding: 16,
          spacing: 12,
          children: [
            UnitHeader(),
            SizedBox(
              height: 12,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return InkWellContainer(
                  onTap: () {},
                  color: Color(0xFF219ABF),
                  radius: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxWidth / 2.7,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: SvgPicture.asset(
                              AssetPath.getVector(
                                'layer1.svg',
                              ),
                              height: constraints.maxWidth / 2.7,
                              fit: BoxFit.fitHeight,
                              color: Color(0xFF29C5F6).withOpacity(.54),
                            ),
                          ),
                          Positioned(
                            child: SvgPicture.asset(
                              AssetPath.getVector(
                                'layer2.svg',
                              ),
                              height: constraints.maxWidth / 2.7,
                              fit: BoxFit.fitHeight,
                              color: Color(0xFF29C5F6).withOpacity(.5),
                            ),
                          ),
                          Positioned(
                            child: SvgPicture.asset(
                              AssetPath.getVector(
                                'layer3.svg',
                              ),
                              height: constraints.maxWidth / 2.7,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            AssetPath.getIcon(
                                                'icon_final_grade.svg'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'Final Grade',
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                  color:
                                                      scaffoldBackgroundColor,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: Text(
                                            'Lorem ipsum dolor sit amet consectetur.',
                                            maxLines: 2,
                                            style:
                                                textTheme.bodySmall?.copyWith(
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
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
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
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_weekly.svg',
                  title: 'Weekly Grades',
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_scientific_assignment.svg',
                  title: 'Scientific Assignment Grade',
                ),
              ],
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_test.svg',
                  title: 'Test Grade',
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_personal_behavior.svg',
                  title: 'Personal Behavior Grade',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AssementMenuCard extends StatelessWidget {
  final String iconPath;
  final String title;
  const AssementMenuCard({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWellContainer(
        onTap: () {},
        radius: 12,
        padding: EdgeInsets.all(20),
        color: scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            color: Color(0xFF374151).withOpacity(.15),
          )
        ],
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: SvgPicture.asset(
                  AssetPath.getIcon(
                    iconPath,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                maxLines: 2,
                style: textTheme.bodyMedium?.copyWith(
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Lorem ipsum dolor sit amet consectetur.',
                maxLines: 2,
                style: textTheme.bodySmall?.copyWith(
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
