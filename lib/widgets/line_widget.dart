import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../repository/latlang.dart';

class Drawing extends StatefulWidget {
  // The widget position on the UI
  final ValueNotifier<ScreenCoordinate> screenPosition;

  final List<Path> drawingPath;
  // The Line geo data
  final LatLng geoCoordinate;

  final double strokeWidth;
  final  Color selectedColor;

  final Widget child;
  Drawing({
    super.key,
    required ScreenCoordinate position,
    required this.geoCoordinate,
    required this.child,
    required this.drawingPath, required this.strokeWidth, required this.selectedColor,
  }) : screenPosition = ValueNotifier(position);

  @override
  DrawingState createState() => DrawingState();
}

class DrawingState extends State<Drawing> {
  DrawingState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = 350.0;
    return ValueListenableBuilder(
      valueListenable: widget.screenPosition,
      builder: (context, pos, child) {
        return Positioned(
          left: pos.x - size/2,
          top: pos.y - size,
          child: GestureDetector(
            onTap: () {},
            child: widget.child,
          ),
        );
      },
    );
  }
}

class DrawPaths extends StatelessWidget {
  final List<Drawing> lines;
  const DrawPaths({super.key, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: lines.toList(),
    );
  }
}

