import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final gemini = Gemini.instance;

//for converting gemini summarize into json
Future<Map<String, dynamic>> geminifunc(
    List<Map<String, dynamic>> transcript) async {
  late Map<String, dynamic> jsonObject;
  String prompt =
      'Summarize the call logs with Name, Place, Date, Time, Total duration, Work, Required Language and return response in json format.';
  final summaryResponse = await gemini.text('$prompt $transcript');
  if (summaryResponse != null &&
      summaryResponse.content != null &&
      summaryResponse.content!.parts != null &&
      summaryResponse.content!.parts!.isNotEmpty) {
    String? jsonText = summaryResponse.content!.parts![0].text
        .toString()
        .replaceAll('```json\n', '');
    String? jsonText_perfect = jsonText.replaceAll('```', '');
    List<dynamic> jsondata = jsonDecode(jsonText_perfect);
    jsonObject = jsondata[0];
  }
  print(jsonObject);
  return jsonObject;

}

//for making call
Future<Map<String, dynamic>> makeCall(String phoneNumber, String task) async {
  // Headers
  Map<String, String> headers = {
    'Authorization':
        'sk-vgd4ggq5h5cijsj2e6f4ru9c04yqo6a6nh1p4sc59xghk8cyddmct7zo118jnm6169',
    'Content-Type': 'application/json',
  };

  // Data
  print(phoneNumber);
  print(task);
  Map<String, dynamic> data = {
    "phone_number": phoneNumber,
    "from": null,
    "task": task,
    "voice": "maya",
    "wait_for_greeting": true,
    "amd": false,
    "record": false,
    "answered_by_enabled": true,
    "interruption_threshold": 50,
    "temperature": 0.8,
    "transfer_phone_number": '+919833369633',
    "first_sentence": 'Welcome to eye connect, how may i can help you?',
    "max_duration": 20,
    "model": "enhanced",
    "language": "eng",
    "start_time": null,
    "tools": [],
    "request_data": {},
  };

  // Convert data to JSON
  String jsonData = json.encode(data);

  try {
    http.Response response = await http.post(
      Uri.parse('https://api.bland.ai/v1/calls'),
      headers: headers,
      body: jsonData,
    );

    // Check response status code
    if (response.statusCode == 200) {
      // Successful request, return decoded JSON data
      Map<String, dynamic> responseData = json.decode(response.body);
      String callId = responseData['call_id'];
      print('$responseData yaha pe ho raha hai data');
      return responseData;
    } else {
      // Handle specific error codes (if needed)
      if (response.statusCode == 429) {
        throw Exception('Too many requests, API rate limit exceeded.');
      } else {
        throw Exception('API call failed with status ${response.statusCode}');
      }
    }
  } catch (error) {
    // Error during API call
    throw Exception('Error making API call: $error');
  }
}

Future<void> fetchLogs(String callId, String number) async {
  try {
    Map<String, String> headers = {
      'Authorization':
          'sk-vgd4ggq5h5cijsj2e6f4ru9c04yqo6a6nh1p4sc59xghk8cyddmct7zo118jnm6169',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {"call_id": callId};
    String jsonData = json.encode(data);
    http.Response response = await http.post(
      Uri.parse('https://api.bland.ai/logs'),
      headers: headers,
      body: jsonData,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('transcripts')) {
          List<dynamic> logs = jsonResponse['transcripts'];

          List<Map<String, dynamic>> transcripts = [];

          for (var logEntry in logs) {
            String message = logEntry['text']; // Extracting the message
            String speaker = logEntry['user']; // Extracting the speaker (user or assistant)
            transcripts.add({'speaker': speaker, 'message': message});
          }
          
          // String transcriptsJson = json.encode(transcripts);
          Map<String, dynamic> summaryinjson = await geminifunc(transcripts);
          Map<String, dynamic> blindData = {
            'Name': summaryinjson["Name"],
            'Place': summaryinjson['Place'],
            'Date' : summaryinjson['Date'],
            'Time' : summaryinjson['Time'],
            'Total Duration': summaryinjson['Total Duration'],
            'Work' : summaryinjson['Work'],
            'Required Language' : summaryinjson['Required Language'],
            'phoneNumber': '$number',
            'Assigned': null,
            'AssignedTo': null,
            'Status': null
          };
          
          try{
            await FirebaseFirestore.instance
              .collection('Scribe Need Request')
              .doc(number)
              .set(blindData);
          }catch(e){
            print(e);
          }
        } else {
          print('No transcripts found in the response');
        }
      } else {
        print('Response body is null or empty');
      }
    } else {
      print('Fetch logs API call failed with status ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching logs: $error');
  }
}
