import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../repository/latlang.dart';

class Marker extends StatefulWidget {
  // The widget position on the UI
  final ValueNotifier<ScreenCoordinate> screenPosition;

  // The Marker image
  final String image;

  // The marker geo data
  final LatLng geoCoordinate;

  final Widget child;
  Marker({
    super.key,
    required ScreenCoordinate position,
    required this.geoCoordinate,
    required this.child,
    required this.image,
  }) : screenPosition = ValueNotifier(position);

  @override
  MarkerState createState() => MarkerState();
}

class MarkerState extends State<Marker> {
  MarkerState();

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
    var size = 60.0;
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

class MapMarkers extends StatelessWidget {
  final List<Marker> markers;
  const MapMarkers({super.key, required this.markers});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: markers.toList(),
    );
  }
}

