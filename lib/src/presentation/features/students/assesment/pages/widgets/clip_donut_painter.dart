import 'package:flutter/material.dart';

// //Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*1.1666666666666667).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

class ClipDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.6666667);
    path_0.cubicTo(size.width, size.height * 1.034856, size.width * 0.6517764,
        size.height * 1.333333, size.width * 0.2222222, size.height * 1.333333);
    path_0.cubicTo(
        size.width * -0.2073319,
        size.height * 1.333333,
        size.width * -0.5555556,
        size.height * 1.034856,
        size.width * -0.5555556,
        size.height * 0.6666667);
    path_0.cubicTo(size.width * -0.5555556, size.height * 0.2984774,
        size.width * -0.2073319, 0, size.width * 0.2222222, 0);
    path_0.cubicTo(size.width * 0.6517764, 0, size.width,
        size.height * 0.2984774, size.width, size.height * 0.6666667);
    path_0.close();
    path_0.moveTo(size.width * -0.3611111, size.height * 0.6666667);
    path_0.cubicTo(
        size.width * -0.3611111,
        size.height * 0.9428095,
        size.width * -0.09994389,
        size.height * 1.166667,
        size.width * 0.2222222,
        size.height * 1.166667);
    path_0.cubicTo(
        size.width * 0.5443889,
        size.height * 1.166667,
        size.width * 0.8055556,
        size.height * 0.9428095,
        size.width * 0.8055556,
        size.height * 0.6666667);
    path_0.cubicTo(
        size.width * 0.8055556,
        size.height * 0.3905238,
        size.width * 0.5443889,
        size.height * 0.1666667,
        size.width * 0.2222222,
        size.height * 0.1666667);
    path_0.cubicTo(
        size.width * -0.09994389,
        size.height * 0.1666667,
        size.width * -0.3611111,
        size.height * 0.3905238,
        size.width * -0.3611111,
        size.height * 0.6666667);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffD1D5DB).withOpacity(.2);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
