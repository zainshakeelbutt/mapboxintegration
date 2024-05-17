
import 'package:flutter/material.dart';

Widget bottomNavWidget({desc,buttonLabel, onPressed}){
  return  Container(
    height: 60,
    color: Colors.orange,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(desc.toString()),
          ElevatedButton(onPressed:onPressed, child: Text(buttonLabel.toString()))
        ],
      ),
    ),
  );
}