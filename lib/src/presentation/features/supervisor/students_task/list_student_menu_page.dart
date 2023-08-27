// import 'package:elogbook/core/context/navigation_extension.dart';
// import 'package:elogbook/core/helpers/asset_path.dart';
// import 'package:elogbook/core/styles/color_palette.dart';
// import 'package:elogbook/core/styles/text_style.dart';
// import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
// import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
// import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
// import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
// import 'package:flutter/material.dart';

// class ListStudentMenuPage extends StatelessWidget {
//   final String title;
//   const ListStudentMenuPage({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     final studentDummyData = [
//       StudentDummyHelper(
//         name: 'Student 1',
//         id: 'H071191049',
//       ),
//       StudentDummyHelper(
//         name: 'Fajri Ganteng',
//         id: 'H071191050',
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ).variant(),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 16,
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: SearchField(
//                   onChanged: (value) {},
//                   text: 'Search',
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 16,
//                 ),
//               ),
//               SliverList.separated(
//                 itemCount: studentDummyData.length,
//                 itemBuilder: (context, index) {
//                   return _buildStudentCard(context, studentDummyData[index]);
//                 },
//                 separatorBuilder: (context, index) {
//                   return SizedBox(
//                     height: 12,
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStudentCard(BuildContext context, StudentDummyHelper student) {
//     return InkWellContainer(
//       color: Colors.white,
//       onTap: () => context.navigateTo(ResidentMenuPage()),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 25,
//             foregroundImage: AssetImage(
//               AssetPath.getImage('profile_default.png'),
//             ),
//           ),
//           SizedBox(
//             width: 12,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 student.name,
//                 style: textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: primaryTextColor,
//                 ),
//               ),
//               Text(
//                 student.id,
//                 style: textTheme.bodyMedium?.copyWith(
//                   color: secondaryTextColor,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
