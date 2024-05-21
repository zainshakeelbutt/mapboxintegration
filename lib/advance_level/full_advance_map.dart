import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapboxintegration/const/colors.dart';
import 'package:mapboxintegration/repository/latlang.dart';
import 'package:mapboxintegration/utils/utils.dart';
import 'package:mapboxintegration/widgets/drawing_lines_widget.dart';
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
  Utils utils = Utils();
  QuestionsRepo questionsRepo = QuestionsRepo();

  var markerPosition = <Position>[];
  var highlightAreaPosition = <Position>[];
  List<Marker> markers = [];
  List<Path> drawingPoints = [];

  double bottomHeight = 50.0;
  int? bottomIconSelectedIndex;
  int gifSelectedIndex = 0;
  String selectedGif = gifImagesList[0];
  bool gestures = true;

  Color selectedColor = Colors.yellow;
  double strokeWidth = 10;




  /* Methods for MapWidget */

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    //Initial Position is Lahore pakistan

    questionsRepo.showMap(mapboxMap, 74.36263544955527, 31.524269220159677);
  }
  _onCameraChangeListener(CameraChangedEventData cameraChangedEventData){
    if(drawingPoints.isNotEmpty){
      gestures = false;
      refreshMapTouchEvents();
      setState(() {});
    }
    updateMarkersPosition();
  }
  _onScrollListener(ScreenCoordinate sc){
    if(drawingPoints.isNotEmpty){
      gestures = false;
      refreshMapTouchEvents();
      setState(() {});
    }
    updateMarkersPosition();
  }
  _onTapListener(ScreenCoordinate coordinates){
    if(bottomIconSelectedIndex == 1){
      _addHighlightedArea(Position(coordinates.y, coordinates.x));
    }
    if(bottomIconSelectedIndex == 2){
      addGifMarker(coordinates.y, coordinates.x,selectedGif);
    }
    if(bottomIconSelectedIndex == 3){
      setState(() {
        markerPosition.add(Position(coordinates.y, coordinates.x));
      });
      questionsRepo.addInteractiveMarkersMap(mapboxMap, markerPosition);
    }
    if(bottomIconSelectedIndex == 4){
      print(coordinates);
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

            // UI for drawn Lines
            CustomPaint(
              painter: DrawingPainter(drawingPoints, selectedColor, strokeWidth),
            ),

            //UI for GIF Markers
            MapMarkers(
              markers: markers.toList(),
            ),

            // Custom Painter to draw lines if line option is selected
            if(bottomIconSelectedIndex == 4)
              DrawingLines(drawingPoints: drawingPoints, strokeWidth: strokeWidth, selectedColor: selectedColor,)
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
                undoHighlightArea();
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



  // Highlighted Area Methods

  void _addHighlightedArea(coordinates){
    setState(() {
      highlightAreaPosition.add(coordinates);
      // _addHighlightedArea(0,highlightedAreaPositions);
      questionsRepo.addHighlightAreaOnMap(mapboxMap, highlightAreaPosition);
    });

    // print(highlightedAreaPositions);

  }


  // Custom Markers Methods

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

  Future<void> updateMarkersPosition() async {
    // We check if any marker is present
    if (markers.isNotEmpty) {
      for (var m in markers) {
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
          highlightAreaIconTap(index);
        }

        else if(index == 2){
          gifIconTap(index);
        }

        else if(index == 3){
          staticMarkerIconTap(index);
        }

        else if(index == 4){
          drawLinesIconTap(index);
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
  //clear All on Tap for Bottom Icons
  clearAllInteractions(){
    setState(() {


    });
  }

  //Add Highlight Area on Tap for Bottom Icons
  highlightAreaIconTap(index){
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

  drawLinesIconTap(index){
    setState(() {
      if(bottomIconSelectedIndex == index){
        bottomIconSelectedIndex = null;
        bottomHeight = 50;
        gestures = true;
        refreshMapTouchEvents();
      } else {
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
  undoHighlightArea(){
    if(highlightAreaPosition.isNotEmpty){
      setState(() {
        highlightAreaPosition.removeLast();
        questionsRepo.addHighlightAreaOnMap(mapboxMap, highlightAreaPosition);

      });
    }
  }

  undoGifMarkers(){
    if(markers.isNotEmpty){
      setState(() {
        markers.removeLast();
      });
    }
  }

  undoLines(){
    if(drawingPoints.isNotEmpty){
      setState(() {
        drawingPoints.removeLast();
      });
    }
  }


}




