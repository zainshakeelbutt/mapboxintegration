import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


Widget speedDialWidget({drawLinesOnTap, drawHighlightOnTap, drawCirclesOnTap, clearOnTap, exitOnTap}){

  return  SpeedDial(
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    spacing: 10,
    animatedIcon: AnimatedIcons.menu_close,
    activeBackgroundColor: Colors.white,
    activeForegroundColor: Colors.grey.shade900,
    backgroundColor: Colors.white,
    foregroundColor: Colors.grey.shade900,
    children: [
      SpeedDialChild(
          child: const Icon(Icons.polyline_rounded),
          label: 'Draw Lines',
          onTap: drawLinesOnTap
      ),

      SpeedDialChild(
          child: const Icon(Icons.area_chart_rounded),
          label: 'Draw Highlighted Area',
          onTap: drawHighlightOnTap
      ),

      SpeedDialChild(
          child: const Icon(Icons.circle),
          label: 'Draw Circles',
          onTap: drawCirclesOnTap
      ),

      SpeedDialChild(
          child: const Icon(Icons.clear_all),
          label: 'Clear All Markers',
          onTap: clearOnTap
      ),
      SpeedDialChild(
          child: const Icon(Icons.arrow_back),
          label: 'Exit',
          onTap: exitOnTap
      ),
    ],
  );

}