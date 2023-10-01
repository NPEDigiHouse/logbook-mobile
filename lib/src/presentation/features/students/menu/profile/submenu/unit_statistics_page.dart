import 'dart:ui' as ui;
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/pdf_helper/pdf_helper.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_card.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_field.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_section.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentStatisticsPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final Uint8List? profilePic;
  final RequestState? stateProfilePic;
  final UserCredential credential;
  const DepartmentStatisticsPage(
      {super.key,
      required this.credential,
      this.profilePic,
      this.stateProfilePic,
      required this.activeDepartmentModel});

  @override
  State<DepartmentStatisticsPage> createState() =>
      _DepartmentStatisticsPageState();
}

class _DepartmentStatisticsPageState extends State<DepartmentStatisticsPage> {
  final GlobalKey keyCase = GlobalKey(debugLabel: 'keyCase');
  final GlobalKey keySkill = GlobalKey(debugLabel: 'keySkill');

  void loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    final List<int> listBytes = data.buffer.asUint8List();
    final Uint8List bytes = Uint8List.fromList(listBytes);
    image = bytes;
  }

  Future<Uint8List> captureWidget(GlobalKey k) async {
    RenderRepaintBoundary boundary =
        k.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  late Uint8List image;

  @override
  void initState() {
    super.initState();
    loadImageFromAssets(AssetPath.getImage('logo_umi.png'));
    Future.microtask(() {
      BlocProvider.of<StudentCubit>(context)..getStudentStatistic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Department Statistics'),
        backgroundColor: scaffoldBackgroundColor.withAlpha(200),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        actions: [
          BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state.studentStatistic != null)
                return IconButton(
                    onPressed: () async {
                      final caseImage = await captureWidget(keyCase);
                      final skillImage = await captureWidget(keySkill);
                      PdfHelper.generate(
                              image: image,
                              profilePhoto: widget.profilePic,
                              caseStat: caseImage,
                              skillStat: skillImage,
                              data: state.studentStatistic,
                              activeUnitName:
                                  widget.activeDepartmentModel.unitName)
                          .whenComplete(() {
                        CustomAlert.success(
                            message: 'Success Download Student Statistic',
                            context: context);
                      });
                    },
                    icon: Icon(Icons.print));
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            DepartmentStatisticsCard(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  iconColor: primaryTextColor,
                  collapsedIconColor: primaryTextColor,
                  tilePadding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
                  childrenPadding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  clipBehavior: Clip.hardEdge,
                  title: Text(
                    widget.credential.fullname ?? '',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.1,
                    ),
                    maxLines: 2,
                  ),
                  subtitle: const Text(
                    'Student',
                    style: TextStyle(color: primaryColor),
                  ),
                  children: <Widget>[
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEFF0F9),
                    ),
                    SizedBox(height: 8),
                    DepartmentStatisticsField(
                      label: 'Student Id',
                      value: widget.credential.student!.studentId,
                    ),
                    DepartmentStatisticsField(
                      label: 'Email',
                      value: widget.credential.email,
                    ),
                    DepartmentStatisticsField(
                      label: 'Phone',
                      value: widget.credential.student!.phoneNumber,
                    ),
                    DepartmentStatisticsField(
                      label: 'Address',
                      value: widget.credential.student!.address,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                if (state.studentStatistic != null) {
                  final stData = state.studentStatistic!;
                  return DepartmentStatisticsCard(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Current Department',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        Text(widget.activeDepartmentModel.unitName ?? ''),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            height: 6,
                            thickness: 6,
                            color: onDisableColor,
                          ),
                        ),
                        DepartmentStatisticsSection(
                          repaintKey: keySkill,
                          titleText: 'Diagnosis Skills',
                          titleIconPath: 'skill_outlined.svg',
                          percentage: (stData.verifiedSkills! /
                                  (stData.totalSkills ?? 1)) *
                              100,
                          statistics: {
                            'Total Diagnosis Skill': stData.totalSkills,
                            'Performed': stData.verifiedSkills,
                            'Not Performed': (stData.totalSkills ?? 0) -
                                stData.verifiedSkills!,
                          },
                          detailStatistics: {
                            1: [
                              ...stData.skills!
                                  .where((element) =>
                                      element.verificationStatus == 'VERIFIED')
                                  .map((e) => e.skillName ?? '')
                                  .toList(),
                            ],
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            height: 6,
                            thickness: 6,
                            color: onDisableColor,
                          ),
                        ),
                        DepartmentStatisticsSection(
                          repaintKey: keyCase,
                          titleText: 'Acquired Cases',
                          titleIconPath: 'attach_resume_male_outlined.svg',
                          percentage: (stData.verifiedCases! /
                                  (stData.totalCases ?? 1)) *
                              100,
                          statistics: {
                            'Total Acquired Case': (stData.totalCases ?? 0),
                            'Identified Case': stData.verifiedCases,
                            'Unidentified Case': (stData.totalCases ?? 0) -
                                stData.verifiedCases!,
                          },
                          detailStatistics: {
                            1: [
                              ...(stData.cases ?? [])
                                  .where((element) =>
                                      element.verificationStatus == 'VERIFIED')
                                  .map((e) => e.caseName ?? '')
                                  .toList(),
                            ],
                          },
                        ),
                      ],
                    ),
                  );
                }
                return CustomLoading();
              },
            ),
          ],
        ),
      ),
    );
  }
}
