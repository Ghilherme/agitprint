import 'package:cloud_firestore/cloud_firestore.dart';

class Gets {
  static Future<List<String>> getDirectorships() async {
    //Pega a tabela categorias somente da categoria selecionada
    List<String> directorships = [];
    await FirebaseFirestore.instance
        .collection('diretorias')
        .orderBy('nome')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return directorships.add(element.data()['nome']);
      });
    });
    return directorships;
  }
}
