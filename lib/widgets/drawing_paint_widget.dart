import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as map;
import 'package:mapboxintegration/repository/latlang.dart';

import 'line_widget.dart';

class DrawingPaths extends StatefulWidget {
  final LatLng lineCoordinates;
  final List<Drawing> pathDrawn;
  final map.MapboxMap mapboxMap;
  final Color selectedColor;
  final PaintingStyle paintingStyle;
  const DrawingPaths({super.key, required this.lineCoordinates, required this.pathDrawn, required this.mapboxMap, required this.selectedColor, required this.paintingStyle,});

  @override
  State<DrawingPaths> createState() => _DrawingPathsState();
}

class _DrawingPathsState extends State<DrawingPaths> {
  double strokeWidth = 5;
  List<Path> drawingPoints = [];
  Offset? lineStartPosition;
  Offset? lineEndPosition;
  // final ValueNotifier<screen.ScreenCoordinate> screenPosition;

  void startStroke(double x, double y){
    drawingPoints.add(Path()..moveTo(x, y));
  }
  void moveStroke(double x, double y){
    setState(() {
      drawingPoints.last.lineTo(x, y);
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

            addCustomLines(widget.lineCoordinates.lat, widget.lineCoordinates.lng, drawingPoints, strokeWidth, widget.selectedColor, widget.paintingStyle);

          },

          child: CustomPaint(
            painter: DrawingPainter(drawingPoints, widget.selectedColor, strokeWidth, widget.paintingStyle),
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
                    drawingPoints.clear();
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

  Future<void> addCustomLines(lat,lng,drawingPoints, strokeWidth, selectedColor, paintingStyle) async {
    // We ask the mapboxMap to give the screen coordinate based on our  location  of type LatLng
    final screenCoordinate = await widget.mapboxMap.pixelForCoordinate(
        map.Point(coordinates: map.Position(lat, lng))
            .toJson());

    // We create the Lines widget with the required data

    var drawing = Drawing(
      position: screenCoordinate,
      geoCoordinate: LatLng(lat: lat, lng: lng),
      drawingPath: drawingPoints,
      strokeWidth: strokeWidth,
      selectedColor: selectedColor,
      child: CustomPaint(
        painter: DrawingPainter(drawingPoints, selectedColor, strokeWidth, paintingStyle),
      ),
    );

    // Add the new Line to list
    widget.pathDrawn.add(drawing);

    // Trigger ui refresh
    setState(() {});
  }

}

class DrawingPainter extends CustomPainter {
  final List<Path> drawingPoints;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;
  DrawingPainter(this.drawingPoints, this.color, this.strokeWidth, this.paintingStyle,);

  @override
  void paint(Canvas canvas, Size size) {

    for( final stroke in drawingPoints){
      final paint = Paint()
        ..strokeWidth = strokeWidth
        ..color = color
        ..style = paintingStyle;
      canvas.drawPath(stroke, paint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
