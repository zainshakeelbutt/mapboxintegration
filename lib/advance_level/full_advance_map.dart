
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapboxintegration/utils/utils.dart';
import 'package:mapboxintegration/widgets/speed_dial_widget.dart';
import '../repository/questions_repo.dart';
import '../widgets/bottom_nav_widget.dart';

class FullAdvanceMap extends StatefulWidget {
  const FullAdvanceMap({super.key});

  @override
  State createState() => FullAdvanceMapState();
}

class FullAdvanceMapState extends State<FullAdvanceMap> {
  MapboxMap? mapboxMap;
  Utils utils = Utils();
  bool drawLines = false;
  bool drawHighlight = false;
  bool drawCircles = false;
  QuestionsRepo questionsRepo = QuestionsRepo();

  var markerPosition = <Position>[];
  var linesPosition = <Position>[];
  var highlightAreaPosition = <Position>[];
  var circlesPosition = <Position>[];

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    //Initial Position is Lahore pakistan
    questionsRepo.showMap(mapboxMap, 74.36263544955527, 31.524269220159677);
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (onPop){
        setState(() {
          drawLines = false;
          drawHighlight = false;
          drawCircles = false;
        });
      },
      child: Scaffold(

          bottomNavigationBar:
          drawLines ? bottomNavWidget(
            desc: 'Add Markers and press Button',
            buttonLabel: 'Draw Lines',
            onPressed: (){
              if(linesPosition.isNotEmpty && linesPosition.length > 1){
                setState(() {
                  questionsRepo.addLinesOnMap(mapboxMap, linesPosition);
                  drawLines = false;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add At least 2 Markers on Map')));
              }

            }
          )
          : drawHighlight ? bottomNavWidget(
              desc: 'Add Markers and press Button',
              buttonLabel: 'Draw Highlight',
              onPressed: (){
                if(highlightAreaPosition.isNotEmpty && highlightAreaPosition.length > 2){
                  setState(() {
                    questionsRepo.addHighlightAreaOnMap(mapboxMap, highlightAreaPosition);
                    drawHighlight = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add At least 3 Markers on Map')));
                }
              }
          )
          : drawCircles ? bottomNavWidget(
          desc: 'Add Circles and press Button',
          buttonLabel: 'Draw Circles',
          onPressed: (){
            if(circlesPosition.isNotEmpty && circlesPosition.length > 1){
              setState(() {
                questionsRepo.addCirclesOnMap(mapboxMap, circlesPosition);
                drawCircles = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add At least 2 Markers on Map')));
            }
          }
          ) : null,

          floatingActionButton: speedDialWidget(
            drawLinesOnTap: (){
              setState(() {
                drawLines = true;
                drawHighlight = false;
                drawCircles = false;

              });
            },
            drawHighlightOnTap: (){
              setState(() {
                drawLines = false;
                drawHighlight = true;
                drawCircles = false;
              });
            },
            drawCirclesOnTap: (){
              setState(() {
                drawLines = false;
                drawHighlight = false;
                drawCircles = true;
              });
            },
            clearOnTap: (){
              drawLines = false;
              drawHighlight = false;
              drawCircles = false;
              markerPosition.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const FullAdvanceMap()));
            },
            exitOnTap: (){
              Navigator.pop(context);
            }
          ),


          body: MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.DARK,
            textureView: true,
            onMapCreated: _onMapCreated,
            onTapListener: (coordinates){
              // print('lat : ${coordinates.x} long : ${coordinates.y}');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('lat : ${coordinates.x} lng : ${coordinates.y}'), duration: const Duration(milliseconds: 800),));

              if(drawLines){
                setState(() {
                  if(!linesPosition.contains(Position(coordinates.y, coordinates.x))){
                    linesPosition.add(Position(coordinates.y, coordinates.x));
                    questionsRepo.addInteractiveMarkersMap(mapboxMap, linesPosition);
                  }
                });
              } else if(drawHighlight){
                setState(() {
                  if(!highlightAreaPosition.contains(Position(coordinates.y, coordinates.x))){
                    highlightAreaPosition.add(Position(coordinates.y, coordinates.x));
                    questionsRepo.addInteractiveMarkersMap(mapboxMap, highlightAreaPosition);
                  }
                });
              } else if(drawCircles){
                setState(() {
                  if(!circlesPosition.contains(Position(coordinates.y, coordinates.x))){
                    circlesPosition.add(Position(coordinates.y, coordinates.x));
                    questionsRepo.addInteractiveMarkersMap(mapboxMap, circlesPosition);
                  }
                });
              } else{
                setState(() {
                  if(!markerPosition.contains(Position(coordinates.y, coordinates.x))){
                    markerPosition.add(Position(coordinates.y, coordinates.x));
                    questionsRepo.addInteractiveMarkersMap(mapboxMap, markerPosition);
                  }
                });
              }



            },
          )

      ),
    );
  }
}
