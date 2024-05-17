

import 'dart:math';
import 'dart:ui';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Utils{

  // Adding predefined positions in a List to draw Line
  List<Position> createLinesPositionList() {
    final positions = <Position>[
      // Position(74.0988781890919, 32.577208677729764),

      // Position(74.17565288099651, 32.656655619831),
      Position(74.20734912904878, 32.649589602617965),
      Position(74.25761520304887, 32.66882368475803),
      Position(74.26944686544428, 32.613830616651256),
      Position(74.0988781890919, 32.577208677729764),

    ];
    return positions;
  }

  // Adding predefined positions in a List to Highlight Area
  List<Position> createHighlightsPositionList() {
    final positions = <Position>[
      // Position(74.0988781890919, 32.577208677729764),

      // Position(74.17565288099651, 32.656655619831),
      Position(74.21056894277444, 32.632399931748296),
      Position(74.14684366057391, 32.598344498373145),
      Position(74.17576710900394, 32.58812761779796),
      Position(74.23729669123624, 32.61252350165071),
      Position(74.21115143568036, 32.63289117499707),

    ];
    return positions;
  }

}

class AnnotationClickListener extends OnPointAnnotationClickListener {

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.geometry!['coordinates']}");
  }
}