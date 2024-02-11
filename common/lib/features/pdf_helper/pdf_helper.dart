import 'dart:io';
import 'package:common/features/file/file_management.dart';
import 'package:core/helpers/utils.dart';
import 'package:data/models/students/student_statistic.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart' as o;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfHelper {
  static Future<String?> generate({
    required Uint8List image,
    required Uint8List? profilePhoto,
    Uint8List? skillStat,
    Uint8List? caseStat,
    StudentStatistic? data,
    String? activeUnitName,
  }) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => buildHeader(image),
      build: (context) => [
        buildBody(profilePhoto, data, activeUnitName),
      ],
    ));
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => buildHeader(image),
      build: (context) => [
        buildCompetence(caseStat, skillStat, data),
        SizedBox(height: 24),
        buildWeeklyScore(data),
        SizedBox(height: 24),
        buildScienceScore(data),
        SizedBox(height: 24),
        buildMiniCexScore(data),
        SizedBox(height: 24),
        buildFinalScore(data),
      ],
    ));

    return PdfApi.saveDocument(name: '${data?.student?.studentId}', pdf: pdf);
  }

  static Widget buildHeader(Uint8List image) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Image(MemoryImage(image)),
              SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FAKULTAS KEDOKTERAN",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'UNIVERSITAS MUSLIM INDONESIA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            color: PdfColors.black,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  static Widget buildBody(
      Uint8List? profilePhoto, StudentStatistic? data, String? departmentName) {
    final studentData = data?.student;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            departmentName ?? '-',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
              ),
            ),
            child: profilePhoto != null
                ? Image(MemoryImage(profilePhoto),
                    width: 80, height: 120, fit: BoxFit.cover)
                : Center(
                    child:
                        Text('No Profile Image', textAlign: TextAlign.center)),
            width: 82,
            height: 122,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Table(
            tableWidth: TableWidth.min,
            border: TableBorder.all(width: 1.2),
            columnWidths: {
              0: const FixedColumnWidth(200),
              1: const FixedColumnWidth(200),
            },
            children: [
              TableRow(
                children: [
                  Text(' Student Name'),
                  Text(' : ${studentData?.fullname ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Clinic Id'),
                  Text(' : ${studentData?.clinicId ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Preclinic Id'),
                  Text(' : ${studentData?.preClinicId ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' S.Ked Graduation Date'),
                  Text(
                      " : ${studentData?.graduationDate != null ? Utils.datetimeToString(DateTime.fromMillisecondsSinceEpoch(studentData!.graduationDate! * 1000)) : '-'}"),
                ],
              ),
              TableRow(
                children: [
                  Text(' Phone Number'),
                  Text(' : ${studentData?.phoneNumber ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Email'),
                  Text(' : ${studentData?.email ?? '-'} '),
                ],
              ),
              TableRow(
                children: [
                  Text(' Address'),
                  Text(' : ${studentData?.address ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Academic Adviser'),
                  Text(' : ${studentData?.academicSupervisorName ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Supervising DPK'),
                  Text(' : ${studentData?.supervisingDPKName ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Examiner DPK'),
                  Text(' : ${studentData?.examinerDPKName ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Period and Length of Station'),
                  Text(' : ${studentData?.periodLengthStation ?? '-'} Weeks'),
                ],
              ),
              TableRow(
                children: [
                  Text(' RS Station'),
                  Text(' : ${studentData?.rsStation ?? '-'}'),
                ],
              ),
              TableRow(
                children: [
                  Text(' PKM Station'),
                  Text(' : ${studentData?.pkmStation ?? '-'}'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildScienceScore(StudentStatistic? data) {
    if (data != null && data.scientificAssesement != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            'C. SCIENTIFIC ASSIGNMENT (CASE REPORT/ REFERAT)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Title: "${data.scientificAssesement?.listScientificAssignmentCase}"',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Table(
              tableWidth: TableWidth.min,
              border: TableBorder.all(width: 1.2),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FixedColumnWidth(300),
                1: const FixedColumnWidth(80),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: PdfColors.black,
                  ),
                  children: [
                    Center(
                      child: Text(
                        'Grade Item',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...[
                  for (int i = 0;
                      i < data.scientificAssesement!.scores!.length;
                      i++)
                    TableRow(
                      children: [
                        Text(
                            ' ${i + 1}. ${data.scientificAssesement?.scores?[i].name}'),
                        Text(' ${data.scientificAssesement?.scores?[i].score}')
                      ],
                    ),
                ],
              ]),
          SizedBox(height: 8),
          Row(children: [
            SizedBox(
              width: 300,
              child: Text(
                'Total Score : ',
                style: TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${data.finalScore?.sa?.score ?? 0}',
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(height: 8),
        ],
      );
    }
    return SizedBox.shrink();
  }

  static Widget buildMiniCexScore(StudentStatistic? data) {
    if (data != null && data.miniCex != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            'D. MINI-CEX ASSESMENT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Title: "${data.miniCex?.dataCase}"',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Table(
              tableWidth: TableWidth.min,
              border: TableBorder.all(width: 1.2),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FixedColumnWidth(300),
                1: const FixedColumnWidth(80),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: PdfColors.black,
                  ),
                  children: [
                    Center(
                      child: Text(
                        'Grade Item',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...[
                  for (int i = 0; i < data.miniCex!.scores!.length; i++)
                    TableRow(
                      children: [
                        Text(' ${i + 1}. ${data.miniCex?.scores?[i].name}'),
                        Text(' ${data.miniCex?.scores?[i].score}')
                      ],
                    ),
                ],
              ]),
          SizedBox(height: 8),
          Row(children: [
            SizedBox(
              width: 300,
              child: Text(
                'Total Score : ',
                style: TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${data.finalScore?.miniCex?.score ?? 0.0}',
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(height: 8),
        ],
      );
    }
    return SizedBox.shrink();
  }

  static Widget buildFinalScore(StudentStatistic? data) {
    if (data != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            'E. FINAL SCORE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Table(
              tableWidth: TableWidth.min,
              border: TableBorder.all(width: 1.2),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FixedColumnWidth(150),
                1: const FixedColumnWidth(80),
                2: const FixedColumnWidth(70),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: PdfColors.black,
                  ),
                  children: [
                    Center(
                      child: Text(
                        'Grade Item',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(' Mini-Cex'),
                    Text(' ${data.finalScore?.miniCex?.score}'),
                    Text(
                        ' ${(data.finalScore?.miniCex?.percentage ?? 0) * 100}%'),
                  ],
                ),
                TableRow(
                  children: [
                    Text(' Scientific Assignment'),
                    Text(' ${data.finalScore?.sa?.score}'),
                    Text(' ${(data.finalScore?.sa?.percentage ?? 0) * 100}%'),
                  ],
                ),
                TableRow(
                  children: [
                    Text(' CBT'),
                    Text(' ${data.finalScore?.cbt?.score}'),
                    Text(' ${(data.finalScore?.cbt?.percentage ?? 0) * 100}%'),
                  ],
                ),
                TableRow(
                  children: [
                    Text(' OSCE'),
                    Text(' ${data.finalScore?.osce?.score}'),
                    Text(' ${(data.finalScore?.osce?.percentage ?? 0) * 100}%'),
                  ],
                ),
              ]),
          SizedBox(height: 8),
          Row(children: [
            SizedBox(
              width: 230,
              child: Text(
                'Total Score : ',
                style: TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${data.finalScore?.finalScore}',
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(height: 8),
        ],
      );
    }
    return SizedBox.shrink();
  }

  static Widget buildWeeklyScore(StudentStatistic? data) {
    if (data != null && data.weeklyAssesment != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            'B. WEEKLY ASSESMENT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Table(
              tableWidth: TableWidth.min,
              border: TableBorder.all(width: 1.2),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FixedColumnWidth(50),
                1: const FixedColumnWidth(100),
                4: const FixedColumnWidth(80),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: PdfColors.black,
                  ),
                  children: [
                    Center(
                      child: Text(
                        'Week',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...[
                  for (int i = 0;
                      i < data.weeklyAssesment!.assesments!.length;
                      i++)
                    TableRow(
                      children: [
                        Center(
                          child: Text(
                              'Week ${data.weeklyAssesment?.assesments?[i].weekNum}'),
                        ),
                        Text(
                            ' ${data.weeklyAssesment?.assesments?[i].verificationStatus}'),
                        Text(
                            ' ${data.weeklyAssesment?.assesments?[i].score?.toStringAsFixed(2)}'),
                      ],
                    )
                ],
              ]),
          SizedBox(height: 8),
          Row(children: [
            SizedBox(
              width: 150,
              child: Text(
                'Total Score : ',
                style: TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              ' ${(data.weeklyAssesment?.assesments?.fold(0, (previousValue, element) => previousValue + (element.score ?? 0)) ?? 0) / (data.weeklyAssesment?.assesments?.length ?? 1)}',
              style: TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(height: 8),
        ],
      );
    }
    return SizedBox.shrink();
  }

  static Widget buildCompetence(
      Uint8List? caseImage, Uint8List? skillImage, StudentStatistic? data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          'A. COMPETENCY',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Acquired Cases',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (caseImage != null)
                  Row(children: [
                    Image(MemoryImage(caseImage), width: 100),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data?.totalCases ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF222431),
                              ),
                            ),
                            Text(
                              'Total Acquired Case',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${data?.verifiedCases ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF229ABF),
                              ),
                            ),
                            Text(
                              'Identified Case',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${(data?.totalCases ?? 0) - (data?.verifiedCases ?? 0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF7209B7),
                              ),
                            ),
                            Text(
                              'Unidentified Case',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                          ]),
                    )
                  ]),
                SizedBox(height: 12),
                if (data != null) ...[
                  for (int i = 0; i < data.cases!.length; i++)
                    Text("${(i + 1)}.${data.cases![i].caseName}")
                ],
              ])),
          SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Diagnostic Skills',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (skillImage != null)
                  Row(children: [
                    Image(MemoryImage(skillImage), width: 100),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data?.totalSkills ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF222431),
                              ),
                            ),
                            Text(
                              'Diagnosis Skills',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${data?.verifiedSkills ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF229ABF),
                              ),
                            ),
                            Text(
                              'Identified Skills',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${(data?.totalSkills ?? 0) - (data?.verifiedSkills ?? 0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF7209B7),
                              ),
                            ),
                            Text(
                              'Unidentified Skills',
                              style: const TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                          ]),
                    )
                  ]),
                SizedBox(height: 12),
                ...[
                  if (data != null) ...[
                    for (int i = 0; i < data.skills!.length; i++)
                      Text("${(i + 1)}.${data.skills![i].skillName}")
                  ],
                ],
              ])),
        ]),
      ],
    );
  }
}

class PdfApi {
  static Future<String?> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    if (Platform.isAndroid) {
      final directory = (await getDownloadsDirectory())!;
      final file = File('${directory.path}/$name.pdf');
      if (await FileManagement.checkAndRequestPermission()) {
        await file.writeAsBytes(bytes);
        await o.OpenFile.open(file.path);
      } else {
        return null;
      }
      return file.path;
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$name.pdf');

      if (await FileManagement.checkAndRequestPermission()) {
        await file.writeAsBytes(bytes);

        try {
          await FileSaver.instance.saveFile(
            name: basename(file.path),
            bytes: bytes,
            mimeType: MimeType.pdf,
          );
        } on PlatformException catch (e) {}
        await o.OpenFile.open(file.path);
      } else {
        return null;
      }
      return file.path;
    } else {
      throw Exception("Platform not supported");
    }
  }
}
