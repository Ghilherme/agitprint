import 'package:firebase_storage/firebase_storage.dart';

class Deletes {
  static void deleteFileImage(String refPath) {
    FirebaseStorage.instance.ref(refPath).delete();
  }
}
