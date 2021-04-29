import 'package:agitprint/payments/payment.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../constants.dart';
import 'body_home_list_people.dart';

class HomeListPeople extends StatefulWidget {
  @override
  _HomeListPeopleState createState() => _HomeListPeopleState();
}

class _HomeListPeopleState extends State<HomeListPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(mainTitleApp),
      ),
      body: BodyHomeListPeople(),
      floatingActionButton: currentPeopleLogged.profiles.contains('user0')
          ? FloatingActionButton(
              child: const Icon(Icons.attach_money),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Payment()));
              },
            )
          : Container(),
    );
  }
}
