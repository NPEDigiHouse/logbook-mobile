// import 'dart:async';

// import 'package:core/styles/color_palette.dart';
// import 'package:flutter/material.dart';

// class CustomBottomAlert extends StatefulWidget {
//   final String message;
//   final bool isFailed;

//   const CustomBottomAlert(
//       {super.key, required this.message, this.isFailed = false});

//   @override
//   _CustomBottomAlertState createState() => _CustomBottomAlertState();
// }

// class _CustomBottomAlertState extends State<CustomBottomAlert>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<Offset> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     ));

//     _animationController.forward();

//     Timer(const Duration(seconds: 1), () {
//       Navigator.of(context).pop();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       transform: Matrix4.translationValues(0, _animation.value.dy, 0),
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               offset: const Offset(0, 4),
//               blurRadius: 8,
//               color: Colors.black.withOpacity(.20),
//             ),
//             BoxShadow(
//               offset: const Offset(0, 0),
//               blurRadius: 4,
//               spreadRadius: 2,
//               color: Colors.black.withOpacity(.10),
//             )
//           ],
//           borderRadius: BorderRadius.circular(8),
//           color: widget.isFailed ? errorColor : primaryColor,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.check_circle,
//               color: scaffoldBackgroundColor,
//             ),
//             const SizedBox(
//               width: 12,
//             ),
//             Expanded(
//               child: Text(
//                 widget.message,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
