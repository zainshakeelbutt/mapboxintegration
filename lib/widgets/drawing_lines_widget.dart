import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as screen;

class DrawingLines extends StatefulWidget {
  final List<Path> drawingPoints;
  final double strokeWidth;
  final  Color selectedColor;
  const DrawingLines({super.key, required this.drawingPoints, required this.strokeWidth, required this.selectedColor, });

  @override
  State<DrawingLines> createState() => _DrawingLinesState();
}

class _DrawingLinesState extends State<DrawingLines> {
  double strokeWidth = 5;
  // List<DrawingPoint> drawingPoints = [];
  // final strokes = <Path>[];
  Offset? lineStartPosition;
  Offset? lineEndPosition;
  // final ValueNotifier<screen.ScreenCoordinate> screenPosition;

  void startStroke(double x, double y){
    widget.drawingPoints.add(Path()..moveTo(x, y));
  }
  void moveStroke(double x, double y){
    setState(() {
      widget.drawingPoints.last.lineTo(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (pos){
            lineStartPosition = pos.globalPosition;
            print('Start From : $lineStartPosition');
          },
          onPanDown: (details)=> startStroke(details.localPosition.dx, details.localPosition.dy),
          onPanUpdate: (details)=> moveStroke(details.localPosition.dx, details.localPosition.dy),
          onPanEnd: (pos){
            lineEndPosition = pos.globalPosition;
            print('End At : $lineEndPosition');
          },
          child: CustomPaint(
            painter: DrawingPainter(widget.drawingPoints, widget.selectedColor, strokeWidth),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 30,
          child: Row(
            children: [
              Slider(
                min: 0,
                max: 40,
                value: strokeWidth,
                onChanged: (val) => setState(() => strokeWidth = val),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    widget.drawingPoints.clear();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text("Clear Lines"),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Path> drawingPoints;
  // final List<DrawingPoint> drawingPoints;

  final Color color;
  final double strokeWidth;
  DrawingPainter(this.drawingPoints, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {

    for( final stroke in drawingPoints){
      final paint = Paint()
        ..strokeWidth = strokeWidth
        ..color = color
        ..style = PaintingStyle.stroke;
      canvas.drawPath(stroke, paint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}