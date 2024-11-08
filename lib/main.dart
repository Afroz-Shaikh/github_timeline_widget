import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // debugShowMaterialGrid: true,
       debugShowCheckedModeBanner: false,
      
      // showPerformanceOverlay: true,
      // showSemanticsDebugger: true,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Afroz!'),
        ),
        body: Container(
          color: Colors.black,
          height: 400,
          width: double.maxFinite,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            
            child: CustomPaint(
              painter: GitHubTimelinePainter(
            contributions:     List.generate(32, (index) => Random().nextInt(15)),
            daysInMonth:     32,
              rows:   5,
             onTapCallback: (index) {
               showDialog(context: context,
               builder: (context) => Dialog(
               child: Text('You clicked on cell index: $index'),
            
               ),
               );
             },  
              ),
              size: Size(550, 400),
            ),
          ),
        ),
      ),
    );
  }
}
class GitHubTimelinePainter extends CustomPainter {
  final List<int> contributions;
  final int daysInMonth;
  final int rows;
  final Function(int index)? onTapCallback;

  GitHubTimelinePainter({
    required this.contributions,
    required this.daysInMonth,
    required this.rows,
    this.onTapCallback,
  });
  



  @override
  void paint(Canvas canvas, Size size) {
    final int columns = (daysInMonth / rows).ceil();
    final double cellSize = size.width / columns;
    final double cellSpacing = 2.0;

    for (int i = 0; i < daysInMonth; i++) {
      final int row = i ~/ columns;
      final int col = i % columns;
      final double x = col * (cellSize + cellSpacing);
      final double y = row * (cellSize + cellSpacing);
      final contributionLevel = contributions[i];
      final color = getColorForContribution(contributionLevel);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw each cell as a rectangle
      canvas.drawRect(
        Rect.fromLTWH(x, y, cellSize, cellSize),
        paint,
      );

      // Draw the index text in the center of each cell
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: Colors.red,
            fontSize: cellSize * 0.3,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: cellSize);

      final offset = Offset(
        x + (cellSize - textPainter.width) / 2,
        y + (cellSize - textPainter.height) / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  Color getColorForContribution(int count) {
    if (count == 0) {
      return Colors.grey[200]!;
    } else if (count <= 2) {
      return Colors.green[100]!;
    } else if (count <= 5) {
      return Colors.green[300]!;
    } else if (count <= 10) {
      return Colors.green[500]!;
    } else {
      return Colors.green[700]!;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}