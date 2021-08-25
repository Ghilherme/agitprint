import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class Uploads {
  static Future<String> uploadFileImageBytes(
      String refPath, Uint8List bytes) async {
    try {
      await FirebaseStorage.instance.ref(refPath).putData(bytes);
    } on FirebaseException catch (e) {
      print(e.message);
    }

    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }
}
