
import 'package:vibration/vibration.dart';

void vibrate() async {
  bool? hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator != null && hasVibrator) {
    
    Vibration.vibrate(duration: 500); // Adjust duration as needed
  }
}