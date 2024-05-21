import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:mapboxintegration/repository/questions_repo.dart';
import 'package:mapboxintegration/utils/utils.dart';

class FullBasicMap extends StatefulWidget {
  const FullBasicMap({super.key});

  @override
  State createState() => FullBasicMapState();
}

class FullBasicMapState extends State<FullBasicMap> {
  MapboxMap? mapboxMap;
  QuestionsRepo questionsRepo = QuestionsRepo();
  Utils utils = Utils();

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    //Implement a simple Flutter app that displays a full-screen Mapbox
    // map using any style map. Include the main Dart file code that initializes the Mapbox map.
    // Setting initial Camera position on Predefined location named Jalalpur Jattan in Pakistan
    questionsRepo.showMap(mapboxMap, 74.2121,32.6480);

    // Extend the app created in Question 2 to add a static marker
    // at a predefined location on the map. Provide the Dart code snippet that achieves this.
    questionsRepo.addStaticMarkerOnMap(mapboxMap);

    // Modify the existing Flutter app to draw a line, a highlighted area,
    // and directional arrows on the map. Ensure these additions are directly on
    // the map and not on a separate layer like a stack. Provide the code snippet
    // for each graphical element.

    //Adding Lines on map
    questionsRepo.addLinesOnMap(mapboxMap, utils.createLinesPositionList());

    //Adding Highlight Area on map
    questionsRepo.addHighlightAreaOnMap(mapboxMap, utils.createHighlightsPositionList());

    //Adding Circles/Arrows on Map
    questionsRepo.addCirclesOnMap(mapboxMap, utils.createLinesPositionList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: MapWidget(
          key: const ValueKey("mapWidget"),
          styleUri: MapboxStyles.SATELLITE_STREETS,
          textureView: true,
          onMapCreated: _onMapCreated,
          // onTapListener: (coordinates){
          //   print('lat : ${coordinates.x} long : ${coordinates.y}');
          // },
        ));
  }
}
