import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapboxintegration/advance_level/full_advance_map.dart';
import 'package:mapboxintegration/basic_level/full_basic_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text('MapBox Integration', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey),),

              const SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullBasicMap()));
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text('Basic Level', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),)),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const FullAdvanceMap()));

                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text('Advance Level', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
