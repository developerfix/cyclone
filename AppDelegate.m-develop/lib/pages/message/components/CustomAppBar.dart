import 'package:Siuu/res/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget title;
  final Widget search;
  final Widget leading;
  final double barHeight;
  final List<Widget> actions;

  CustomAppBar({
    this.leading,
    this.barHeight,
    this.title,
    this.actions,
    this.search,
  });

  CustomAppBar copyWith({double barHeight}) {
    return CustomAppBar(
      leading: leading,
      title: title,
      search: search,
      actions: actions,
      barHeight: barHeight ?? this.barHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return CustomPaint(
      child: Container(
        padding: EdgeInsets.only(top: statusbarHeight, bottom: 40),
        height: statusbarHeight + barHeight,
        child: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  if (leading != null) leading,
                  Expanded(
                    child: Center(child: title),
                  ),
                  if (actions != null)
                    Row(
                      children: actions.map((e) => e).toList(),
                    ),
                  if (search != null)
                    SizedBox(
                      width: 48,
                    )
                ],
              ),
            ),
            if (search != null)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: search,
                ),
              ),
          ],
        ),
      ),
      painter: AppBarPainter(),
    );
  }
}

class AppBarPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final double extra = 40;
    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = new Paint()
      ..shader = linearGradient.createShader(colorBounds);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.arcToPoint(Offset(extra, size.height - extra),
        radius: Radius.circular(extra));
    path.lineTo(size.width - extra, size.height - extra);

    path.arcToPoint(Offset(size.width, size.height),
        radius: Radius.circular(extra));
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
