import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apis/gets.dart';
import 'constants.dart';
import 'home/home_dashboard.dart';
import 'home/home_list_people.dart';
import 'login/login.dart';
import 'models/people.dart';
import 'models/status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool('logado') ?? false;
  if (status) {
    PeopleModel people =
        await Gets.getUserInfo(prefs.getString('logado_email') ?? '');
    if (people.status == Status.disabled) {
      prefs.setBool('logado', false);
      status = false;
    } else {
      //coloca na constants para uso em memoria do app
      idPeopleLogged =
          FirebaseFirestore.instance.collection('pessoas').doc(people.id);
      currentPeopleLogged = PeopleModel.fromPeople(people);
    }
  }
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: mainTitleApp,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: status
          ? currentPeopleLogged.profiles.contains('admin3')
              ? HomeListPeople()
              : HomeDashboard(
                  people: currentPeopleLogged,
                )
          : Login()));
}
