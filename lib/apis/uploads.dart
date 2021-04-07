import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Uploads {
  static Future<String> uploadFileImage(String refPath, String filePath) async {
    File file = File(filePath);

    await FirebaseStorage.instance.ref(refPath).putFile(file);
    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }
}
