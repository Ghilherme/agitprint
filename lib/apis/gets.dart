import 'dart:convert';

import 'package:agitprint/models/banks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  static Future<List<BankModel>> readBankJson() async {
    List<BankModel> banks = [];
    final String response =
        await rootBundle.loadString('assets/json/banks_list.json', cache: true);
    List<dynamic> data = json.decode(response);
    data.forEach((value) {
      return banks.add(BankModel(value['value'], value['label']));
    });
    return banks;
  }
}
