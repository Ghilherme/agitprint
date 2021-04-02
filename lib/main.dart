import 'package:agitprint/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('logado') ?? false;
  if (status) {
    idPeopleLogged =
        FirebaseFirestore.instance.doc(prefs.getString('logado_id') ?? '');
    currentPeopleLogged.profiles = prefs.getStringList('logado_acessos') ?? [];
    currentPeopleLogged.directorship =
        prefs.getString('logado_directorship') ?? '';
    currentPeopleLogged.email = prefs.getString('logado_email') ?? '';
    currentPeopleLogged.name = prefs.getString('logado_name') ?? '';
    currentPeopleLogged.imageAvatar = prefs.getString('logado_avatar') ?? '';
  }
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: mainTitleApp,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: status ? HomeScreen() : Login()));
}
