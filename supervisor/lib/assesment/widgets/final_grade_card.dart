import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:main/widgets/inkwell_container.dart';

import '../pages/student_final_score_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class FinalGradeCard extends StatefulWidget {
  const FinalGradeCard({super.key});

  @override
  State<FinalGradeCard> createState() => _FinalGradeCardState();
}

class _FinalGradeCardState extends State<FinalGradeCard> {
  @override
  void initState() {
    super.initState();
    //GANTI SETELAH ADA ACTIVE UNIT
    BlocProvider.of<AssesmentCubit>(context).getStudentFinalScore();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssesmentCubit, AssesmentState>(
      builder: (context, state) {
        if (state.finalScore != null) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return InkWellContainer(
                onTap: () => context.navigateTo(const StudentDetailFinalScorePage()),
                color: const Color(0xFF219ABF),
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
                            color: const Color(0xFF29C5F6).withOpacity(.54),
                          ),
                        ),
                        Positioned(
                          child: SvgPicture.asset(
                            AssetPath.getVector(
                              'layer2.svg',
                            ),
                            height: constraints.maxWidth / 2.6,
                            fit: BoxFit.fitHeight,
                            color: const Color(0xFF29C5F6).withOpacity(.5),
                          ),
                        ),
                        Positioned(
                          child: SvgPicture.asset(
                            AssetPath.getVector(
                              'layer3.svg',
                            ),
                            height: constraints.maxWidth / 2.6,
                            fit: BoxFit.fitHeight,
                            color: const Color(0xFF29C5F6),
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
                                        padding: const EdgeInsets.all(4.0),
                                        width: 38,
                                        height: 38,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: scaffoldBackgroundColor,
                                        ),
                                        child: SvgPicture.asset(
                                          AssetPath.getIcon(
                                              'icon_final_grade.svg'),
                                        ),
                                      ),
                                      const SizedBox(
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
                                          'Final Score',
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
                                        margin: const EdgeInsets.all(14),
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF7EC5DB),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            e.toStringAsFixed(1),
                                            style:
                                                textTheme.titleMedium?.copyWith(
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
                                          const Color(0xFF2AC5F7),
                                          const Color(0xFFA2E8FF),
                                          const Color(0xFF89E1FD),
                                        ],
                                        trackColor: const Color(0xFFADDAE7),
                                      ),
                                    ),
                                    min: 0,
                                    max: 100,
                                    initialValue:
                                        state.finalScore!.finalScore ?? 0,
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
        } else {
          if (state.stateSa == RequestState.loading) {
            return CustomShimmer(
                child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  height: 120,
                  width: double.infinity,
                ),
              ],
            ));
          }
          return const SizedBox.shrink();
        }
      },
    );
  }
}
