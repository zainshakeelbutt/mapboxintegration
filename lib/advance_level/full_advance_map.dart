import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapboxintegration/const/colors.dart';
import 'package:mapboxintegration/repository/latlang.dart';
import 'package:mapboxintegration/utils/utils.dart';
import 'package:mapboxintegration/widgets/drawing_paint_widget.dart';
import 'package:mapboxintegration/widgets/line_widget.dart';
import '../const/strings.dart';
import '../repository/questions_repo.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/marker_widget.dart';

class FullAdvanceMap extends StatefulWidget {
  const FullAdvanceMap({super.key});

  @override
  State createState() => FullAdvanceMapState();
}

class FullAdvanceMapState extends State<FullAdvanceMap> {
  MapboxMap? mapboxMap;
  QuestionsRepo questionsRepo = QuestionsRepo();

  var markerPosition = <Position>[];
  List<Marker> markers = [];
  List<Drawing> linesDrawn =[];
  List<Drawing> highlightAreasDrawn =[];

  double bottomHeight = 50.0;
  int? bottomIconSelectedIndex;
  int gifSelectedIndex = 0;
  String selectedGif = gifImagesList[0];
  bool gestures = true;
  Color selectedColor = Colors.yellow;

  LatLng? linesCoordinates;


  /* Methods for MapWidget */

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    //Initial Position is Lahore pakistan
    questionsRepo.showMap(mapboxMap, 74.36263544955527, 31.524269220159677);
  }
  _onCameraChangeListener(CameraChangedEventData cameraChangedEventData){
    updateGifMarkersOrLinesOrHighlightedAreaPosition(markers);
    updateGifMarkersOrLinesOrHighlightedAreaPosition(linesDrawn);
    updateGifMarkersOrLinesOrHighlightedAreaPosition(highlightAreasDrawn);
  }
  _onScrollListener(ScreenCoordinate sc){
    updateGifMarkersOrLinesOrHighlightedAreaPosition(markers);
    updateGifMarkersOrLinesOrHighlightedAreaPosition(linesDrawn);
    updateGifMarkersOrLinesOrHighlightedAreaPosition(highlightAreasDrawn);
  }
  _onTapListener(ScreenCoordinate coordinates){

    // when gif marker option selected
    if(bottomIconSelectedIndex == 2){
      addGifMarker(coordinates.y, coordinates.x,selectedGif);
    }
    // when Static marker option selected
    if(bottomIconSelectedIndex == 3){
      setState(() {
        markerPosition.add(Position(coordinates.y, coordinates.x));
      });
      questionsRepo.addInteractiveMarkersMap(mapboxMap, markerPosition);
    }
    //When Highlighted Area or Line drawing option Selected
    if(bottomIconSelectedIndex == 1 || bottomIconSelectedIndex == 4){
      setState(() {
        linesCoordinates = LatLng(lat: coordinates.y, lng: coordinates.x);
      });
      print('lat: ${linesCoordinates?.lat} lng : ${linesCoordinates?.lng}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack(
          children: [
            //Map Ui
            MapWidget(
              key: const ValueKey("mapWidget"),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
              // gestureRecognizers: < Factory < OneSequenceGestureRecognizer >> {
              //   Factory < OneSequenceGestureRecognizer > (
              //         () => EagerGestureRecognizer(),
              //   ),
              // },
              onCameraChangeListener:  _onCameraChangeListener,
              onScrollListener: _onScrollListener,
              onTapListener: _onTapListener,
            ),

            // UI for Highlighted Areas
            DrawPaths(lines: highlightAreasDrawn.toList()),

            // UI for drawn Lines
            DrawPaths(lines: linesDrawn.toList()),

            //UI for GIF Markers
            MapMarkers(markers: markers.toList()),

            // Custom Painter to draw lines if line option is selected
            if(bottomIconSelectedIndex == 1 && linesCoordinates != null)
              DrawingPaths(lineCoordinates: linesCoordinates!, pathDrawn:highlightAreasDrawn, mapboxMap:mapboxMap!, selectedColor: selectedColor.withOpacity(0.5), paintingStyle: PaintingStyle.fill),

            // Custom Painter to draw lines if line option is selected
            if(bottomIconSelectedIndex == 4 && linesCoordinates != null)
              DrawingPaths(lineCoordinates: linesCoordinates!, pathDrawn:linesDrawn, mapboxMap:mapboxMap!, selectedColor: selectedColor, paintingStyle: PaintingStyle.stroke)
          ],
        ),

        bottomNavigationBar: bottomNavWidget(
            bottomHeight: bottomHeight,
            bottomIconSelectedIndex: bottomIconSelectedIndex,
            // Gif images menu UI
            gifChildren: List.generate(gifImagesList.length, (index) => _buildGifChildren(index)),

            // Colors menu UI
            colorsChildren: List.generate(lineColors.length, (index) => _buildColorChose(lineColors[index])),

            // Undo tap UI
            undoTap: (){

              if(bottomIconSelectedIndex == 1){
                undoHighlightedArea();
              }
              if(bottomIconSelectedIndex == 2){
                undoGifMarkers();
              }
              if(bottomIconSelectedIndex == 4){
                undoLines();
              }

            },

            // Bottom bar Icons UI
            bottomIconChildren: List.generate(bottomBarIcons.length, (index) => _buildBottomIconChildren(index))
        )

    );
  }

  // Custom Markers Methods

  //Method to Add Gif Marker on Map
  Future<void> addGifMarker(lat,lng,image) async {
    var iconSize = 60.0;

     // We ask the mapboxMap to give the screen coordinate based on our  location  of type LatLng
    final screenCoordinate = await mapboxMap!.pixelForCoordinate(
        Point(coordinates: Position(lat, lng))
            .toJson());


     // We create the marker widget with the required data
    var marker = Marker(
      position: screenCoordinate , // the screen position
      geoCoordinate: LatLng(lat: lat, lng: lng),
      image: image,
      child: Image.asset(image, width: iconSize,
      ), // My Widget I want to show on the map
    );

    // Add the new marker to list
    markers.add(marker);
    // Trigger ui refresh
    setState(() {});
  }

  /* Single method to update position of Gif Markers, Lines And Highlighted Area
  according to Map position by just changing the parameter */
  Future<void> updateGifMarkersOrLinesOrHighlightedAreaPosition(markerOrLines) async {
    // We check if any marker is present
    if (markerOrLines.isNotEmpty) {
      for (var m in markerOrLines) {
        /* For ever marker previously added
          we ask the mapboxmap to give the screenCoordinate corresponding to the geo coordinate
         */
        final screenCoordinate = await mapboxMap!.pixelForCoordinate(Point(
            coordinates: Position(m.geoCoordinate.lat, m.geoCoordinate.lng))
            .toJson());
        // We update the new screen position
        m.screenPosition.value = screenCoordinate;
        setState(() {});
      }
    }
  }


  /* Bottom Icon Section */

  /*Bottom Nav Bar Components */

  //Colors list in children
  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 30 : 20,
        width: isSelected ? 30 : 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  //Gif Images List in Children
  Widget _buildGifChildren(index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          gifSelectedIndex = index;
          selectedGif = gifImagesList[index];
        });
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: index == gifSelectedIndex ? Colors.white.withOpacity(0.6) : Colors.transparent,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Image.asset(gifImagesList[index], width: 35, height: 35,)),
    );
  }

  //Bottom Option Icons List in Children
  Widget _buildBottomIconChildren(index){
    return GestureDetector(
      onTap: (){

        if(index == 0){
          // clearAllInteractions();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const FullAdvanceMap()));
        }

        else if(index == 1){
          drawLinesOrHighlightedAreaIconTap(index);
        }

        else if(index == 2){
          gifIconTap(index);
        }

        else if(index == 3){
          staticMarkerIconTap(index);
        }

        else if(index == 4){
          drawLinesOrHighlightedAreaIconTap(index);
        }

        else {
          gestures = true;
          bottomHeight = 50;
          bottomIconSelectedIndex = null;
          setState(() {

          });
        }
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ( index >0 && index == bottomIconSelectedIndex )? Colors.orange.withOpacity(0.6) :  Colors.transparent,
              borderRadius: BorderRadius.circular(12)
          ),
          child: Icon(bottomBarIcons[index], size: 35, color: index == 0 ? Colors.blue : Colors.grey.shade600,)),
    );
  }

  /*onTap methods Implementation */

  //onTap method for Gif marker
  gifIconTap(index){
    setState(() {
      if(bottomIconSelectedIndex == index){
        bottomIconSelectedIndex = null;
        bottomHeight = 50;
      } else {
        bottomIconSelectedIndex = index;
        gestures = true;
        if(bottomHeight == 50){
          bottomHeight = bottomHeight *2;
        } else {
          bottomHeight = 50;
          bottomIconSelectedIndex = null;
        }
      }
    });
  }

  //onTap method for static marker
  staticMarkerIconTap(index){
    setState(() {
      if(bottomIconSelectedIndex == index){
        bottomIconSelectedIndex = null;
        bottomHeight = 50;
      } else {
        bottomIconSelectedIndex = index;
        bottomHeight = 50;
        gestures = true;
      }
    });
  }

  //onTap method for drawing highlighted area or drawing lines on map
  drawLinesOrHighlightedAreaIconTap(index){
    setState(() {
      if(bottomIconSelectedIndex == index){
        bottomIconSelectedIndex = null;
        bottomHeight = 50;
        gestures = true;
        refreshMapTouchEvents();
        linesCoordinates = null;
      } else {
        linesCoordinates = null;
        bottomIconSelectedIndex = index;
        bottomHeight = 50;
        gestures = false;

        refreshMapTouchEvents();
        if(bottomHeight == 50){
          bottomHeight = bottomHeight*2;
        } else{
          bottomHeight = 50;
          bottomIconSelectedIndex = null;
        }
      }
    });
  }

  //onTap method to make map on a static position and make it do not move
  refreshMapTouchEvents(){
    setState(() {
      mapboxMap!.gestures.updateSettings(GesturesSettings(rotateEnabled: gestures));
      mapboxMap!.gestures.updateSettings(GesturesSettings(pinchToZoomEnabled: gestures));
      mapboxMap!.gestures.updateSettings(GesturesSettings(doubleTapToZoomInEnabled: gestures));
      mapboxMap!.gestures.updateSettings(GesturesSettings(scrollEnabled: gestures));
      mapboxMap!.gestures.updateSettings(GesturesSettings(pinchPanEnabled: gestures));
      mapboxMap!.gestures.updateSettings(GesturesSettings(pinchToZoomDecelerationEnabled: gestures));
    });
  }

  //Undo Section onTap methods Implementation

  undoGifMarkers(){
    if(markers.isNotEmpty){
      setState(() {
        markers.removeLast();
      });
    }
  }

  undoLines(){
    if(linesDrawn.isNotEmpty){
      setState(() {
        linesDrawn.removeLast();
      });
    }
  }

  undoHighlightedArea(){
    if(highlightAreasDrawn.isNotEmpty){
      setState(() {
        highlightAreasDrawn.removeLast();
      });
    }
  }


}




