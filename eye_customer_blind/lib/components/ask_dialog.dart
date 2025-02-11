import 'dart:async';
import 'package:eye_customer_blind/model/container_interaction.dart';
import 'package:eye_customer_blind/model/recording_request.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
final stt.SpeechToText speech = stt.SpeechToText();

//   Future<void> initSpeechToText() async {
//   // Initialize the SpeechToText instance
//   await speech.initialize(
//     onStatus: (status) => print('Speech status: $status'),
//     onError: (error) => print('Speech error: $error'),
//   );
// }
// Future<void> showPhoneNumberDialog(BuildContext context,String text,int selectionnumber) async {
//   final FlutterTts flutterTts = FlutterTts();
//   String phoneNumber = '';

//   await initSpeechToText();
//   await flutterTts.awaitSpeakCompletion(true);

//   await flutterTts.speak(text);
//   speech.listen(
//     onResult: (result) {
//       phoneNumber = result.recognizedWords.replaceAll(' ', '');
//       Navigator.of(context).pop(phoneNumber);
//       selectionnumber==1?callresponse(phoneNumber): pickPDFFile(phoneNumber);
//     },
//     listenFor: Duration(seconds: 30),
//     pauseFor: Duration(seconds: 5),
//     cancelOnError: true,
//     partialResults: false,
//   );

//   await showDialog(
//   context: context,
//   barrierDismissible: false, // Disables dismissing the dialog by tapping outside
//   builder: (BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       child: Container(
//         decoration: BoxDecoration(color: Colors.transparent),
//         child: Image.asset('assets/voiceani.gif'),
//       ),
//     );
//   },
// );


// }

Timer? _timer;

Future<void> initSpeechToText() async {
  await speech.initialize(
    onStatus: (status) => print('Speech status: $status'),
    onError: (error) => print('Speech error: $error'),
  );
}

Future<void> showPhoneNumberDialog(BuildContext context, String text, int selectionnumber) async {
  final FlutterTts flutterTts = FlutterTts();
  String phoneNumber = '';

  await initSpeechToText();
  await flutterTts.awaitSpeakCompletion(true);

  await flutterTts.speak(text);

  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Image.asset('assets/voiceani.gif'),
        ),
      );
    },
  );

  _timer = Timer(Duration(seconds: 5), () {
    // Close the dialog after 5 seconds of pause
    if (speech.isListening) {
      _timer?.cancel();
    } else {
      Navigator.of(context).pop();
    }
  });

  speech.listen(
    onResult: (result) {
      phoneNumber = result.recognizedWords.replaceAll(' ', '');
      Navigator.of(context).pop(); // Close the dialog
      _timer?.cancel(); // Cancel the timer if speech recognition is completed
      selectionnumber == 1 ? callresponse(phoneNumber) : uploadPDF(phoneNumber);
      
    },
    listenFor: Duration(seconds: 30),
    cancelOnError: true,
    partialResults: false,
  );
}
