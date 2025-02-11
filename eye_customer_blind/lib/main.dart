import 'package:eye_customer_blind/model/speech_to_text.dart';
import 'package:eye_customer_blind/view/first_page.dart';
import 'package:eye_customer_blind/view/object_detection.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_core/firebase_core.dart';


List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(
    generationConfig: GenerationConfig(temperature: 0.75),
    apiKey: 'AIzaSyDnJ1MY51s68ovSdiZW6NxIBH3PV_xFBRI',
    );
    
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: 'AIzaSyCg2XkugwdD7L1T3VAZlZEItp230okFIqg',
    appId: '1:471654402450:android:01972f967d22abc943994b',
    messagingSenderId: '471654402450',
    projectId: 'eyeconnect-4dcb2',
    storageBucket: 'eyeconnect-4dcb2.appspot.com',
  ),);
  runApp(MainPage());
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> speakAndBuildApp() async {
    await speak("Welcome to Eye Connect");
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: speakAndBuildApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Image.asset('assets/mic.gif'),);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return MaterialApp(
            title: 'EyeConnect',
            debugShowCheckedModeBanner: false,
            home: ImageIdentifierScreen(),
          );
        }
      },
    );
  }
}
