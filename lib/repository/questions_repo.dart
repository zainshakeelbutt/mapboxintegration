import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../utils/utils.dart';

class QuestionsRepo {

  // Setting  Camera position on any Predefined location
  showMap(mapboxMap, lng, lat){
    mapboxMap?.setCamera(CameraOptions(
        center: Point(coordinates: Position(lng, lat)).toJson(),
        zoom: 10.0, pitch: 0
    ));
  }


  // Creating and Adding Markers on Map
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;

  // Method for static marker on predefined location named Jalalpur Jattan in Pakistan
  void addStaticMarker(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
        geometry: Point(
            coordinates: Position(
              74.17536772637473, 32.65579451572698,
            )).toJson(),
        textField: "Static Marker",
        textOffset: [0.0, -2.0],
        textColor: Colors.red.value,
        iconSize: 0.10,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: list))
        .then((value) => pointAnnotation = value);
  }

  addStaticMarkerOnMap(mapboxMap){
    // Adding Marker Marker and setting Icon
    mapboxMap?.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load('assets/symbols/custom-icon.png');
      final Uint8List list = bytes.buffer.asUint8List();
      addStaticMarker(list);
      pointAnnotationManager?.addOnPointAnnotationClickListener(AnnotationClickListener());
    });
  }

  addInteractiveMarkersMap(mapboxMap,markerPosition){

    mapboxMap?.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load(
          'assets/symbols/custom-icon.png');
      final Uint8List list = bytes.buffer.asUint8List();
      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < markerPosition.length; i++) {
        options.add(
            PointAnnotationOptions(
                geometry: Point(coordinates: markerPosition[i]).toJson(),
                textOffset: [0.0, -2.0],
                textColor: Colors.red.value,
                iconSize: 0.12,
                iconOffset: [0.0, -5.0],
                symbolSortKey: 10,
                image: list));
      }
      pointAnnotationManager?.createMulti(options);
      pointAnnotationManager?.addOnPointAnnotationClickListener(AnnotationClickListener());

    });

  }

  deleteAllMarkers(){
    pointAnnotationManager?.deleteAll();
  }


  // Creating and Adding Lines on Map
  PolylineAnnotation? polylineAnnotation;
  PolylineAnnotationManager? polylineAnnotationManager;

  void addLinePositions(markerPosition) {
    polylineAnnotationManager
        ?.create(PolylineAnnotationOptions(
        geometry: LineString(coordinates:markerPosition).toJson(),
        lineColor: Colors.red.value,
        lineJoin: LineJoin.MITER,
        lineWidth: 7))
        .then((value) => polylineAnnotation = value);
  }

  // Adding Lines on Map
  addLinesOnMap(mapboxMap,markerPosition){
    mapboxMap?.annotations.createPolylineAnnotationManager().then((value){
      polylineAnnotationManager =value;
      addLinePositions(markerPosition);
    });
  }


  // Creating and Adding Highlighted Areas on Map
  PolygonAnnotation? polygonAnnotation;
  PolygonAnnotationManager? polygonAnnotationManager;

  void addHighlightPositions(markerPosition) {
    polygonAnnotationManager
        ?.create(PolygonAnnotationOptions(
        geometry: Polygon(coordinates:[markerPosition]).toJson(),
        fillColor: Colors.red.withOpacity(0.5).value,
        fillOutlineColor: Colors.purple.value))
        .then((value) => polygonAnnotation = value);
  }

  addHighlightAreaOnMap(mapboxMap, markerPosition){
    mapboxMap?.annotations.createPolygonAnnotationManager().then((value){
      polygonAnnotationManager =value;
      addHighlightPositions(markerPosition);
    });
  }


  // Creating and Adding Circles Areas on Map
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;

  addCirclesOnMap(mapboxMap, markerPosition){
    mapboxMap?.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
      // createOneAnnotation();

      var options = <CircleAnnotationOptions>[];
      for (var i = 0; i < markerPosition.length; i++) {
        options.add(CircleAnnotationOptions(
            geometry: Point(coordinates: markerPosition[i]).toJson(),
            circleColor: Colors.yellow.value,
            circleRadius: 8.0,
        ));
      }
      circleAnnotationManager?.createMulti(options);
    });
  }


}