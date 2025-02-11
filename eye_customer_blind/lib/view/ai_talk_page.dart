import 'dart:async';
import 'package:eye_customer_blind/model/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

// class ChatbotScreen extends StatefulWidget {
//   @override
//   _ChatbotScreenState createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   final gemini = Gemini.instance;
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   bool _isListening = false;
//   String? _finalResponse;
//   Timer? _responseTimer;

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   Future<void> _initSpeech() async {
//     bool available = await _speech.initialize();
//     if (!available) {
//       print('Speech recognition not available');
//     }
//   }

//   void _startListening() {
//     if (!_isListening) {
//       _speech.listen(
//         onResult: _onSpeechResult,
//         localeId: 'en_US',  
//       );
//       setState(() {
//         _isListening = true;
//         _finalResponse = null;
//       });
//     }
//   }

//   void _stopListening() {
//     if (_isListening) {
//       _speech.stop();
//       setState(() {
//         _isListening = false;
//       });
//     }
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) async {
//     if (result.finalResult) {
//       _stopListening();
//       try {
//         final prompt = result.recognizedWords + ' in 2 lines only';
//         final generationConfig = GenerationConfig(topP: 0.9);
//         final apiResponse = await gemini.text(prompt, generationConfig: generationConfig);
//         final responseText = apiResponse?.content?.parts?.last.text;
//         setState(() {
//           _finalResponse = responseText;
//         });
//         _tts.speak(_finalResponse!);
//       } catch (e) {
//         print('Failed to get response from AI: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI Companion'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//            GestureDetector(
//               onHorizontalDragEnd: (DragEndDetails details) {
//         Navigator.pop(context);
//   },
//              child: Container(
//                      width: 200, 
//                      height: 200,
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        boxShadow: [
//                    BoxShadow(
//                      color: Colors.black.withOpacity(0.3),
//                      spreadRadius: 2,
//                      blurRadius: 5,
//                      offset: Offset(0, 3), 
//                    ),
//                        ],
//                      ),
//                      child: ElevatedButton(
//                        onPressed: _isListening ? _stopListening : _startListening,
//                        style: ElevatedButton.styleFrom(
//                    shape: CircleBorder(), 
//                    padding: EdgeInsets.all(30), 
//                        ),
//                        child: Center(
//                    child: Text(
//                      _isListening ? 'Stop Listening' : 'Talk to AI Assistant',
//                      style: TextStyle(fontSize: 18), 
//                    ),
//                        ),
//                      ),
//                    ),
//            ),
//             SizedBox(height: 16.0),
//             _isListening ? VoiceRecordingAnimation() : SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VoiceRecordingAnimation extends StatefulWidget {
//   @override
//   _VoiceRecordingAnimationState createState() => _VoiceRecordingAnimationState();
// }

// class _VoiceRecordingAnimationState extends State<VoiceRecordingAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: VoiceRecordingPainter(_animation.value),
//           size: Size(100, 100),
//         );
//       },
//     );
//   }
// }

// class VoiceRecordingPainter extends CustomPainter {
//   final double value;

//   VoiceRecordingPainter(this.value);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;

//     final radius = size.width / 2;
//     final centerX = size.width / 2;
//     final centerY = size.height / 2;

//     final waveRadius = radius * (1 + value * 0.5);

//     canvas.drawCircle(Offset(centerX, centerY), radius, paint);
//     canvas.drawCircle(Offset(centerX, centerY), waveRadius, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }



class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final gemini = Gemini.instance;
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String? _finalResponse;
  // Timer? _responseTimer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose(){
    _stopListening();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      print('Speech recognition not available');
    }
  }

  void _startListening() {
    if (!_isListening) {
      _speech.listen(
        onResult: _onSpeechResult,
        localeId: 'en_US',
      );
      setState(() {
        _isListening = true;
        _finalResponse = null;
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      _stopListening();
      try {
        final prompt = result.recognizedWords + ' in 2 lines only';
        final generationConfig = GenerationConfig(topP: 0.9);
        final apiResponse = await gemini.text(prompt, generationConfig: generationConfig);
        final responseText = apiResponse?.content?.parts?.last.text;
        setState(() {
          _finalResponse = responseText;
        });
        _tts.speak(_finalResponse!);
      } catch (e) {
        print('Failed to get response from AI: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
                  speak('Back To Home Page');
                  Navigator.pop(context);
                },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('AI Companion'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Image.asset(
                  'assets/rokid_wave_sound_fantasy.gif',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.0),
              if (_finalResponse != null) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _finalResponse!,
                    style: TextStyle(fontSize: 18.0,color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}