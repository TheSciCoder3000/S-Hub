import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  // Layer 1
  
  Paint paintFill0 = Paint()
    ..color = const Color.fromARGB(238, 88, 254, 171)
    ..style = PaintingStyle.fill
    ..strokeWidth = size.width*0.00
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;
    
        
  Path path_0 = Path();
  path_0.moveTo(size.width*-0.0033333,0);
  path_0.lineTo(size.width*1.0016667,size.height*0.0021605);
  path_0.lineTo(size.width*1.0018500,size.height*0.7772209);
  path_0.quadraticBezierTo(size.width*0.9430500,size.height*0.7995170,size.width*0.8666167,size.height*0.8136897);
  path_0.cubicTo(size.width*0.7771167,size.height*0.8281973,size.width*0.6317000,size.height*0.8112592,size.width*0.5597833,size.height*0.7975078);
  path_0.cubicTo(size.width*0.4555667,size.height*0.7829570,size.width*0.3038667,size.height*0.7901729,size.width*0.2252833,size.height*0.8068410);
  path_0.cubicTo(size.width*0.1185000,size.height*0.8244057,size.width*0.0683167,size.height*0.8499642,size.width*-0.0010833,size.height*0.8787201);
  path_0.quadraticBezierTo(size.width*-0.0019167,size.height*0.6742850,size.width*-0.0033333,0);
  path_0.close();

  canvas.drawPath(path_0, paintFill0);
  

  // Layer 1
  
  Paint paintStroke0 = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.00
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;
    
        
  
  canvas.drawPath(path_0, paintStroke0);
  

  // Layer 1 Copy
  
  Paint paintFill1 = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.width, size.height),
      [const Color(0xff459efc), const Color(0xff20febb)]
    )
    ..style = PaintingStyle.fill
    ..strokeWidth = size.width*0.00
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;
    
        
  Path path_1 = Path();
  path_1.moveTo(size.width*-0.0033333,size.height*-0.0080000);
  path_1.lineTo(size.width*1.0016667,size.height*-0.0058137);
  path_1.lineTo(size.width*1.0013333,size.height*0.7477100);
  path_1.quadraticBezierTo(size.width*0.8930167,size.height*0.7878714,size.width*0.8165833,size.height*0.8022004);
  path_1.cubicTo(size.width*0.7270833,size.height*0.8168657,size.width*0.5789500,size.height*0.8041765,size.width*0.5070333,size.height*0.7902680);
  path_1.cubicTo(size.width*0.3903833,size.height*0.7603992,size.width*0.2382167,size.height*0.7822794,size.width*0.1902167,size.height*0.7945314);
  path_1.cubicTo(size.width*0.0948167,size.height*0.8212300,size.width*0.0415500,size.height*0.8507709,size.width*-0.0003167,size.height*0.8813376);
  path_1.quadraticBezierTo(size.width*-0.0011500,size.height*0.6746608,size.width*-0.0033333,size.height*-0.0080000);
  path_1.close();

  canvas.drawPath(path_1, paintFill1);
  

  // Layer 1 Copy
  
  Paint paintStroke1 = Paint()
    ..color = const Color.fromARGB(0, 33, 149, 243)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size.width*0.00
    ..strokeCap = StrokeCap.butt
    ..strokeJoin = StrokeJoin.miter;
    
        
  
  canvas.drawPath(path_1, paintStroke1);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
