import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesModel {
  CategoriesModel({@required this.name, @required this.description, this.id});
  String id, name, description;

  CategoriesModel.fromCategories(CategoriesModel categorie) {
    this.id = categorie.id;
    this.name = categorie.name;
    this.description = categorie.description;
  }
  CategoriesModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.data()['nome'];
    this.description = snapshot.data()['descricao'];
  }

  CategoriesModel.empty() {
    this.name = '';
    this.description = '';
  }
}
