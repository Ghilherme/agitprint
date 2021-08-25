import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DirectorshipModel {
  DirectorshipModel({@required this.name, @required this.description, this.id});
  String id, name, description;

  DirectorshipModel.fromDirectories(DirectorshipModel directorie) {
    this.id = directorie.id;
    this.name = directorie.name;
    this.description = directorie.description;
  }
  DirectorshipModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.get('nome');
    this.description = snapshot.get('descricao');
  }

  DirectorshipModel.empty() {
    this.name = '';
    this.description = '';
  }
}
