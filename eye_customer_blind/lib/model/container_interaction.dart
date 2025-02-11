import 'package:eye_customer_blind/components/ask_dialog.dart';
import 'package:eye_customer_blind/view/ai_talk_page.dart';
import 'package:eye_customer_blind/view/object_detection.dart';
import 'package:flutter/material.dart';
import 'package:eye_customer_blind/model/blend_call.dart';

void callresponse(String phone) async {
  try {
    String phoneNumber = "+91$phone";
    print(phoneNumber);     
    String task = "If someone ask for urgent help only then transfer the call otherwise Talk as if you are desgined to take requests from blind people regarding need of volunteers for their any writing work or exam. Ask their name first and after response secondly ask their location third ask for the date required fourth ask for time and total duration required and final ask for type of help needed and in last ask in which language. ";
    Map<String, dynamic> response = await makeCall(phoneNumber, task);
    print('Make call response: $response');
    await Future.delayed(const Duration(minutes: 3));
    String callId = response['call_id'];
    print(callId);
    await fetchLogs(callId,phoneNumber);
  } catch (error) {
    print(error);
  }
}

void onTapContainer(int index ,context) async {
    int Value = index;
    print('Executing onTap function of Container ${index + 1}');
    if (Value == 2) {
      showPhoneNumberDialog(context,'Please say your phone number',4);  
    }else if (Value == 1) {
      // callresponse();
      showPhoneNumberDialog(context,'Please say your phone number',1); 
    }else if (Value == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatbotScreen()),
      );
    }else if (Value == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageIdentifierScreen()),
      );
      
    }
  }
