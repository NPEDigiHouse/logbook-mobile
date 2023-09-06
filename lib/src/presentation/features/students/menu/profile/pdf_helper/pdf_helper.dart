import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfHelper {
  static Future<File> generate(
      {required Uint8List image, required Uint8List? profilePhoto}) async {
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
      build: (context) => [buildBody(profilePhoto)],
    ));
    print('test');

    return PdfApi.saveDocument(name: 'doc.pdf', pdf: pdf);
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
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Departemen Ilmu Kesehatan Anak',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
          ),
        ),
        child: profilePhoto != null
            ? Image(MemoryImage(profilePhoto),
                width: 80, height: 120, fit: BoxFit.cover)
            : Center(child: Text('No Profile Image')),
        width: 82,
        height: 122,
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
      )
    ]);
  }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final _directory = Directory("/storage/emulated/0/Download");
    // final dir = await getApplicationDocumentsDirectory();
    final file = File('${_directory.path}/$name');

    await file.writeAsBytes(bytes);

    openFile(file);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print(url);
    await OpenFile.open(url);
  }
}
