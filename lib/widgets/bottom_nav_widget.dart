
import 'package:flutter/material.dart';

Widget bottomNavWidget({
  bottomHeight,bottomIconSelectedIndex,
  gifChildren, colorsChildren, undoTap, bottomIconChildren
}){
  return  Container(
    height: bottomHeight,
    decoration: const BoxDecoration(
        color: Colors.white
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(bottomHeight == 100 && bottomIconSelectedIndex ==2)
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: gifChildren,
              ),
            ),
          ),
        if(bottomHeight == 100 && (bottomIconSelectedIndex == 1 || bottomIconSelectedIndex ==4))
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: colorsChildren,
              ),
            ),
          ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(bottomIconSelectedIndex != 0 && bottomIconSelectedIndex != 3 && bottomIconSelectedIndex != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: undoTap,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: const Icon(Icons.undo_outlined, color: Colors.red, size: 35,)),
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bottomIconChildren,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

