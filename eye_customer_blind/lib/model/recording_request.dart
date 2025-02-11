import 'package:eye_customer_blind/model/speech_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> uploadPDF(String phoneNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf','docx','pptx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('dcuments_uploads/${result.files.single.name}');

      try {
        // Upload the file
        TaskSnapshot uploadTask = await ref.putFile(file);

        // Get the download URL
        String downloadURL = await ref.getDownloadURL();
        DateTime now = DateTime.now();
        final dateFormatter = DateFormat('yyyy-MM-dd').format(now);

        // Store the download URL in Firestore
        await FirebaseFirestore.instance.collection('recording_requests').doc(phoneNumber).set({
          'file_name': result.files.single.name,
          'url': downloadURL,
          'phone_number' : phoneNumber,
          'status' : false,
          'Uploaded_by' : '',
          'Request_Date': dateFormatter,
          'Received Date' : ''
        }).then((value) => speak("Recording Request Sent Successfully"));

        print('File uploaded successfully');
      } catch (e) {
        print('Error occurred while uploading: $e');
      }
    } else {
      // User canceled the picker
    }
}