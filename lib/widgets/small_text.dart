import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;


  SmallText({
    this.color = const Color(0xff000000),
    required this.text,
    this.size=12,
    this.height=1.2
    });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Varela',
        color: color,
        height: height
      ),
    );
  }
}
