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
    this.name = snapshot.get('nome');
    this.description = snapshot.get('descricao');
  }

  CategoriesModel.empty() {
    this.name = '';
    this.description = '';
  }
}
