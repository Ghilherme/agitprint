import 'package:agitprint/payments/payment.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../constants.dart';
import 'body_home.dart';
import 'body_home_list_people.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Accounts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: Text(mainTitleApp),
          ),
          body: acessPeopleLogged.contains('admin3')
              ? BodyHomeListPeople()
              : BodyHome(),
          floatingActionButton: acessPeopleLogged.contains('user0')
              ? FloatingActionButton(
                  child: const Icon(Icons.attach_money),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Payment()));
                  },
                )
              : Container(),
        ));
  }
}
