// import 'package:elogbook/core/helpers/asset_path.dart';
// import 'package:elogbook/core/styles/text_style.dart';
// import 'package:elogbook/src/presentation/features/students/menu/profile/pdf_helper/pdf_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ExportDataPage extends StatefulWidget {
//   final Uint8List? memoryImage;
//   const ExportDataPage({super.key, required this.memoryImage});

//   @override
//   State<ExportDataPage> createState() => _ExportDataPageState();
// }

// class _ExportDataPageState extends State<ExportDataPage> {
//   void loadImageFromAssets(String path) async {
//     final ByteData data = await rootBundle.load(path);
//     final List<int> listBytes = data.buffer.asUint8List();
//     final Uint8List bytes = Uint8List.fromList(listBytes);
//     image = bytes;
//   }

//   late Uint8List image;

//   @override
//   void initState() {
//     super.initState();
//     loadImageFromAssets(AssetPath.getImage('logo_umi.png'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate PDF'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FilledButton(
//               onPressed: () {
//                 PdfHelper.generate(
//                     image: image, profilePhoto: widget.memoryImage);
//               },
//               child: Text('Generate PDF'),
//             ),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Image.asset(AssetPath.getImage('logo_umi.png')),
//           Column(
//             children: [
//               Text(
//                 "FAKULTAS KEDOKTERAN",
//                 style: textTheme.displayMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'UNIVERSITAS MUSLIM INDONESIA',
//                 style: textTheme.displayMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildBody(BuildContext context) {
//     return Column();
//   }
// }
