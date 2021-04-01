import 'dart:convert';

import 'package:agitprint/models/banks.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/models/providers.dart';
import 'package:agitprint/models/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Gets {
  static Future<List<String>> getDirectorships() async {
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

  static Future<List<String>> getCategories() async {
    List<String> categories = [];
    await FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('nome')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return categories.add(element.data()['nome']);
      });
    });
    return categories;
  }

  static Query getProvidersQuery() {
    return FirebaseFirestore.instance
        .collection('fornecedores')
        .orderBy('nome')
        .where('status', isEqualTo: Status.active);
  }

  static Future<List<ProvidersModel>> getProviders() async {
    List<ProvidersModel> providers = [];
    await getProvidersQuery().get().then((value) {
      value.docs.forEach((element) {
        return providers.add(ProvidersModel.fromFirestore(element));
      });
    });
    return providers;
  }

  static Query _getProvidersAdminQuery(String directorship) {
    return FirebaseFirestore.instance
        .collection('fornecedores')
        .where('diretoria', isEqualTo: directorship);
  }

  static Future<ProvidersModel> getProvidersAdmin(String directorship) async {
    List<ProvidersModel> providers = [];
    await _getProvidersAdminQuery(directorship).get().then((value) {
      value.docs.forEach((element) {
        return providers.add(ProvidersModel.fromFirestore(element));
      });
    });
    return providers.first;
  }

  static Stream<QuerySnapshot> getPaymentsStream(String idPeople) {
    DocumentReference doc =
        FirebaseFirestore.instance.collection('pessoas').doc(idPeople);
    return FirebaseFirestore.instance
        .collection('pagamentos')
        .where('pessoa', isEqualTo: doc)
        .orderBy('datasolicitacao')
        .snapshots();
  }

  static Stream<DocumentSnapshot> getPeopleStream(String idPeople) {
    return FirebaseFirestore.instance
        .collection('pessoas')
        .doc(idPeople)
        .snapshots();
  }

  static Future<PeopleModel> getUserInfo(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('pessoas')
        .where('email', isEqualTo: email)
        .get();
    return PeopleModel.fromFirestore(query.docs.first);
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
