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

  static Query getAllActiveProvidersQuery() {
    return FirebaseFirestore.instance
        .collection('fornecedores')
        .orderBy('nome')
        .where('status', isEqualTo: Status.active);
  }

  static Future<List<ProvidersModel>> getAllActiveProviders() async {
    List<ProvidersModel> providers = [];
    await getAllActiveProvidersQuery().get().then((value) {
      value.docs.forEach((element) {
        return providers.add(ProvidersModel.fromFirestore(element));
      });
    });
    return providers;
  }

  static Query getProvidersByDirectorshipQuery(
      String directorship, String status) {
    return FirebaseFirestore.instance
        .collection('fornecedores')
        .where('diretoria', isEqualTo: directorship)
        .where('status', isEqualTo: status);
  }

  static Future<ProvidersModel> getProvidersById(
      DocumentReference idProvider) async {
    DocumentSnapshot doc = await idProvider.get();
    return ProvidersModel.fromFirestoreDocument(doc);
  }

  static Future<List<ProvidersModel>> getProviderByDirectorship(
      String directorship, String status) async {
    List<ProvidersModel> providers = [];
    await getProvidersByDirectorshipQuery(directorship, status)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return providers.add(ProvidersModel.fromFirestore(element));
      });
    });
    return providers;
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

  static Query getPeopleByDirectorshipQuery(
      String directorship, String status) {
    return FirebaseFirestore.instance
        .collection('pessoas')
        .where('diretoria', isEqualTo: directorship)
        .where('status', isEqualTo: status);
  }

  static Query getAllActivePeopleQuery() {
    return FirebaseFirestore.instance
        .collection('pessoas')
        .orderBy('nome')
        .where('status', isEqualTo: Status.active);
  }

  static Future<List<PeopleModel>> getAllActivePeople() async {
    List<PeopleModel> people = [];
    await getAllActivePeopleQuery().get().then((value) {
      value.docs.forEach((element) {
        return people.add(PeopleModel.fromFirestore(element));
      });
    });
    return people;
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
