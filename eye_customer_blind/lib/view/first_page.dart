
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eye_customer_blind/model/container_interaction.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:eye_customer_blind/model/phone_vibrate.dart';
import 'package:eye_customer_blind/model/speech_to_text.dart';

class firstPage extends StatefulWidget {
  const firstPage({Key? key}) : super(key: key);

  @override
  _firstPageState createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    speak("Welcome to Eye Connect");
  }

  int currentContainerIndex = 0;
  double threshold = 0.9;
  double verticalThreshold = 0.5;
  bool containerChanged = false;
  List<bool> containerFocused = [false, false, false];
  @override
  Widget build(BuildContext context) {
    const  LinearGradient backgroundGradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 191, 184, 245),
        Color.fromARGB(255, 74, 110, 226)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 74, 110, 226),
                Color.fromARGB(255, 191, 184, 245)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor:
            Colors.transparent,
        centerTitle: true,
        title: const Text(
          'EyeConnect',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          children: [
            Row(
              children: [
                buildContainer('Personal', Colors.white10, 0),
                buildContainer('Volunteer Assist', Colors.white10, 1),
              ],
            ),
            Row(children: [
              buildContainer('Need Recording', Colors.white10, 2),
              buildContainer('Identify', Colors.white10, 3),
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.width / 3,
            ),


//-----------------Swipe Based Controlling---------------------//
            GestureDetector(
              onDoubleTap: (){
                 onTapContainer(currentContainerIndex,
                    context); 
              },
              onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! < 0) {
            setState(() {
              currentContainerIndex--;
            });
          } else if (details.primaryVelocity! > 0) {
            setState(() {
              currentContainerIndex++;
            });
          }
        },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                          width: double.infinity,
                          height: 270,
                          child: Icon(Icons.touch_app, size: 60, color: Colors.grey[100]),
                          decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(42)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: const Offset(0, 20),
                      blurRadius: 30,
                      spreadRadius: -5,
                    ),
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black12,
                        Colors.black26,
                        Colors.black38,
                        Colors.black87,
                      ],
                      stops: const [
                        0.1,
                        0.3,
                        0.9,
                        1.0
                      ])),
                        ),
              ),
            ),

        

          ],
        ),
      ),
    );
  }

  Widget buildContainer(String text, Color color, int index) {
    index == currentContainerIndex ? speak(text) : null;
    return GestureDetector(
      onTap: () {
        // HapticFeedback.lightImpact();
        print('Container ${index + 1} pressed');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.2,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            color: color,
            boxShadow: index == currentContainerIndex
                ? [
                    BoxShadow(
                      color: const Color.fromARGB(255, 166, 176, 255).withOpacity(
                          0.5), // Adjust the opacity and color as needed
                      spreadRadius: 10.0, // Spread radius
                      blurRadius: 10.0, // Blur radius
                    ),
                  ]
                : null,
            border: Border.all(
              color:
                  index == currentContainerIndex ? Colors.blue : Colors.black,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 19),
            softWrap: true,
          )),
        ),
      ),
    );
  }
}





// Conatiner scroll Joystick

// GestureDetector(
//               onDoubleTap: () {
//                 onTapContainer(currentContainerIndex,
//                     context); // Perform double click action
//               },
//               onHorizontalDragUpdate: (details) {
//                 if (details.delta.dx > 0 && currentContainerIndex < 3) {
//                   setState(() {
//                     currentContainerIndex++; // Increment index on swipe right
//                   });
//                 } else if (details.delta.dx < 0 && currentContainerIndex > 0) {
//                   setState(() {
//                     currentContainerIndex--; // Decrement index on swipe left
//                   });
//                 }
//               },
//               onVerticalDragUpdate: (details) {
//                 if (details.delta.dy > 0 && currentContainerIndex < 3) {
//                   setState(() {
//                     currentContainerIndex++; // Increment index on swipe down
//                   });
//                 } else if (details.delta.dy < 0 && currentContainerIndex > 0) {
//                   setState(() {
//                     currentContainerIndex--; // Decrement index on swipe up
//                   });
//                 }
//               },
//               child: Container(
//                 width: double.infinity, // Adjust width as needed
//                 height: 200, // Adjust height as needed
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black,
//                       Colors.grey
//                     ], // Define gradient colors
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Swipe or Double Tap',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),



//circle joystick based control
// GestureDetector(
//               // onPanStart: (details) => Vibration.vibrate(duration: 100),
//               onTapDown: (details) {
//                 // HapticFeedback.heavyImpact();
//                 vibrate();
//               },
//               // onPanDown: (details) => vibrate(),
//               onDoubleTap: () => onTapContainer(currentContainerIndex, context),
//               child: Container(
//                 width: 250,
//                 height: 250,
//                 decoration: const BoxDecoration(
//                   color: Colors.black, // Change color to desired color
//                   shape: BoxShape.circle,
//                 ),
//                 child: Joystick(
//                   listener: (details) {
//                     double x = details.x;
//                     double y = details.y;
//                     if (!containerChanged &&
//                         ((x.abs() > threshold) || (y.abs() > threshold))) {
//                       containerChanged = true;
//                       if (x.abs() > y.abs()) {
//                         if (x > 0 && currentContainerIndex < 3) {
//                           setState(() {
//                             currentContainerIndex++;
//                           });
//                         } else if (x < 0 && currentContainerIndex > 0) {
//                           setState(() {
//                             currentContainerIndex--;
//                           });
//                         }
//                       } else {
//                         if (y > verticalThreshold &&
//                             currentContainerIndex < 3) {
//                           setState(() {
//                             currentContainerIndex++;
//                           });
//                         } else if (y < -verticalThreshold &&
//                             currentContainerIndex > 0) {
//                           setState(() {
//                             currentContainerIndex--;
//                           });
//                         }
//                       }
//                       // Delay resetting the flag to allow for a brief pause before allowing another container change
//                       Future.delayed(Duration(milliseconds: 700), () {
//                         containerChanged =
//                             false; // Reset the flag after a brief delay
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),








