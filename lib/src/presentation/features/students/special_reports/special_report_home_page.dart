import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/features/students/special_reports/add_special_report_page.dart';
import 'package:elogbook/src/presentation/features/students/special_reports/widgets/special_report_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpecialReportHomePage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const SpecialReportHomePage({super.key, required this.activeUnitModel});

  @override
  State<SpecialReportHomePage> createState() => _SpecialReportHomePageState();
}

class _SpecialReportHomePageState extends State<SpecialReportHomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpecialReportCubit>(context)..getStudentSpecialReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Special Reports"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SpacingColumn(
            onlyPading: true,
            horizontalPadding: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UnitHeader(
                    unitName: widget.activeUnitModel.unitName!,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  AddNewConsultionCard(),
                  BlocBuilder<SpecialReportCubit, SpecialReportState>(
                    builder: (context, state) {
                      if (state.specialReport != null)
                        return Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'List of Consultation on Encountered Issues',
                              style: textTheme.titleMedium?.copyWith(
                                height: 1.1,
                                color: secondaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            ListView.separated(
                              itemBuilder: (context, index) {
                                return SpecialReportCard(
                                  data: state.specialReport!
                                      .listProblemConsultations![index],
                                  index: index + 1,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 12,
                                );
                              },
                              itemCount: state.specialReport!
                                  .listProblemConsultations!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ],
                        );
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewConsultionCard extends StatelessWidget {
  const AddNewConsultionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: () => context.navigateTo(AddSpecialReportPage()),
      color: primaryColor,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: Opacity(
                opacity: .3,
                child: SvgPicture.asset(
                  AssetPath.getVector('ellipse_1.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Opacity(
                opacity: .6,
                child: SvgPicture.asset(
                  AssetPath.getVector('half_ellipse.svg'),
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Add new consultation issue',
                        style: textTheme.titleMedium?.copyWith(
                          color: scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Add the consultation problems found during stage',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.75),
                        ),
                      )
                    ],
                  )),
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
