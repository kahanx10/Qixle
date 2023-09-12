// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final double? elevation;
  final bool isTitleCentered;
  // And any other properties we like.

  const MyAppBar({
    Key? key,
    this.title,
    this.actions,
    this.elevation,
    this.isTitleCentered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: preferredSize,
      painter: CurvedAppBarPainter(borderColor: Colors.grey.shade300),
      child: SizedBox(
        height: preferredSize.height,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(child: title),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class CurvedAppBarPainter extends CustomPainter {
  final double curveHeight;
  final Color appBarColor;
  final Color borderColor;
  final double borderWidth;

  CurvedAppBarPainter({
    this.curveHeight = 30.0,
    this.appBarColor = Constants.backgroundColor,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint appBarPaint = Paint()
      ..color = appBarColor
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    Path appBarPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - curveHeight)
      ..quadraticBezierTo(
          size.width / 2, size.height, 0, size.height - curveHeight)
      ..close();

    Path borderPath = Path()
      ..moveTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - curveHeight);

    canvas.drawPath(appBarPath, appBarPaint);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
