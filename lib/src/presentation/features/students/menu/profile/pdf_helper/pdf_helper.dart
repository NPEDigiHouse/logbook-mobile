import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfHelper {
  static Future<File> generate({
    required Uint8List image,
    required Uint8List? profilePhoto,
    Uint8List? skillStat,
    Uint8List? caseStat,
  }) async {
    var myTheme = ThemeData.withFont(
      base:
          Font.ttf(await rootBundle.load("fonts/PlusJakartaSans-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("fonts/PlusJakartaSans-Bold.ttf")),
    );

    final pdf = Document(
      theme: myTheme,
    );

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => buildHeader(image),
      build: (context) => [
        buildBody(profilePhoto),
      ],
    ));
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => buildHeader(image),
      build: (context) => [
        buildCompetence(caseStat, skillStat),
        SizedBox(height: 48),
        buildWeeklyScore(),
        SizedBox(height: 48),
        buildScienceScore(),
        SizedBox(height: 48),
        buildMiniCexScore(),
        SizedBox(height: 48),
        buildFinalScore(),
      ],
    ));

    return PdfApi.saveDocument(name: 'Statistic', pdf: pdf);
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
            padding: EdgeInsets.symmetric(vertical: 12),
            height: 4,
            color: PdfColors.black,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  static Widget buildBody(Uint8List? profilePhoto) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Departemen Ilmu Kesehatan Anak',
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
              0: FixedColumnWidth(200),
              1: FixedColumnWidth(200),
            },
            children: [
              TableRow(
                children: [
                  Text(' Student Name'),
                  Text(' : Masloman'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Clinic Id'),
                  Text(' : 0912431412'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Preclinic Id'),
                  Text(' : 0912431412'),
                ],
              ),
              TableRow(
                children: [
                  Text(' S.Ked Graduation Date'),
                  Text(' : 02 Januari 2025'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Phone Number'),
                  Text(' : 08231241242'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Email'),
                  Text(' : phantom@gmail.com'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Address'),
                  Text(' : Makassar'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Academic Adviser'),
                  Text(' : Toriq'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Supervising DPK'),
                  Text(' : Abdul'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Examiner DPK'),
                  Text(' : Komar'),
                ],
              ),
              TableRow(
                children: [
                  Text(' Period and Length of Station'),
                  Text(' : 11 Weeks'),
                ],
              ),
              TableRow(
                children: [
                  Text(' RS Station'),
                  Text(' : RSUD Makassar'),
                ],
              ),
              TableRow(
                children: [
                  Text(' PKM Station'),
                  Text(' : Location 1'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildScienceScore() {
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
          'Title: \"ini tempat judul\"',
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
              0: FixedColumnWidth(300),
              1: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
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
              TableRow(
                children: [Text('1. Bla bla bla'), Text('90')],
              ),
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
            '95',
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

  static Widget buildMiniCexScore() {
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
          'Title: \"ini tempat judul\"',
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
              0: FixedColumnWidth(300),
              1: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
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
              TableRow(
                children: [Text('1. Bla bla bla'), Text('90')],
              ),
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
            '95',
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

  static Widget buildFinalScore() {
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
              0: FixedColumnWidth(150),
              1: FixedColumnWidth(80),
              2: FixedColumnWidth(70),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
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
                  Text('Bla bla bla'),
                  Text('90'),
                  Text('10%'),
                ],
              ),
              TableRow(
                children: [
                  Text('Bla bla bla'),
                  Text('90'),
                  Text('10%'),
                ],
              ),
              TableRow(
                children: [
                  Text('Bla bla bla'),
                  Text('90'),
                  Text('10%'),
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
            '95',
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

  static Widget buildWeeklyScore() {
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
        Text(
          'Notes: Attend 0 Days, Not Attend 11 Days',
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
              0: FixedColumnWidth(50),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(100),
              4: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
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
                      'Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Location',
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
              TableRow(
                children: [
                  Center(
                    child: Text('1'),
                  ),
                  Text(' 12 Jan 2023'),
                  Text(' RS Hasanuddin'),
                  Text(' VERIFIED'),
                  Text(' 90'),
                ],
              ),
              TableRow(
                children: [
                  Center(
                    child: Text('2'),
                  ),
                  Text(' 12 Jan 2023'),
                  Text(' RS Hasanuddin'),
                  Text(' VERIFIED'),
                  Text(' 90'),
                ],
              ),
              TableRow(
                children: [
                  Center(
                    child: Text('3'),
                  ),
                  Text(' 12 Jan 2023'),
                  Text(' RS Hasanuddin'),
                  Text(' VERIFIED'),
                  Text(' 90'),
                ],
              ),
            ]),
        SizedBox(height: 8),
        Row(children: [
          SizedBox(
            width: 350,
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
            '95',
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

  static Widget buildCompetence(Uint8List? caseImage, Uint8List? skillImage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        Row(children: [
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
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF222431),
                              ),
                            ),
                            Text(
                              'Total Acquired Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF229ABF),
                              ),
                            ),
                            Text(
                              'Identified Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF7209B7),
                              ),
                            ),
                            Text(
                              'Unidentified Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                          ]),
                    )
                  ]),
                SizedBox(height: 12),
                ...[
                  Text('1. Case 1'),
                  Text('2. Case 2'),
                  Text('3. Case 3'),
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
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF222431),
                              ),
                            ),
                            Text(
                              'Total Acquired Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF229ABF),
                              ),
                            ),
                            Text(
                              'Identified Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${10 ?? 0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xFF7209B7),
                              ),
                            ),
                            Text(
                              'Unidentified Case',
                              style: TextStyle(
                                color: PdfColor.fromInt(0xFFBBBEC1),
                              ),
                            ),
                          ]),
                    )
                  ]),
                SizedBox(height: 12),
                ...[
                  Text('1. Skill 1'),
                  Text('2. Skill 2'),
                  Text('3. Skill 3'),
                ],
              ])),
        ]),
      ],
    );
  }
}

Future<bool> checkAndRequestPermission() async {
  final plugin = DeviceInfoPlugin();
  final android = await plugin.androidInfo;

  var status = android.version.sdkInt < 33
      ? await Permission.storage.request()
      : PermissionStatus.granted;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
    // final dir = await getApplicationDocumentsDirectory();
    String? savePath = '${_directory.path}/$name.pdf';
    File file = File(savePath);

    if (await checkAndRequestPermission()) {
      await file.writeAsBytes(bytes);
    }

    return file;
  }
}
