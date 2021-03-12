import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height * 0.8);

    var firstEndpoint = Offset(size.width * 0.6, size.height * 0.55);
    var firstControlPoint = Offset(size.width * 0.40, size.height);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy);

    var secondEndpoint = Offset(size.width * 0.8, size.height * 0.35);
    var secondControlPoint = Offset(size.width * 0.7, size.height * 0.35);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndpoint.dx, secondEndpoint.dy);

    var thirdEndpoint = Offset(size.width * 0.9, size.height * 0.25);
    var thirdControlPoint = Offset(size.width * 0.9, size.height * 0.35);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndpoint.dx, thirdEndpoint.dy);

    var fourthEndpoint = Offset(size.width * 0.78, size.height * 0.15);
    var fourthControlPoint = Offset(size.width * 0.9, size.height * 0.15);

    path.quadraticBezierTo(fourthControlPoint.dx, fourthControlPoint.dy,
        fourthEndpoint.dx, fourthEndpoint.dy);

    var fifthEndpoint = Offset(size.width * 0.5, size.height * 0);
    var fifthControlPoint = Offset(size.width * 0.6, size.height * 0.15);

    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fifthEndpoint.dx, fifthEndpoint.dy);
//    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
