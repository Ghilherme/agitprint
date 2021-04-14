import 'package:agitprint/home/body_home_dashboard.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/payments/payment.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../constants.dart';

class HomeDashboard extends StatefulWidget {
  final PeopleModel people;

  const HomeDashboard({Key key, @required this.people}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: currentPeopleLogged.profiles.contains('admin3')
          ? null
          : CustomDrawer(),
      appBar: AppBar(
        leading: currentPeopleLogged.profiles.contains('admin3')
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        centerTitle: true,
        elevation: 0,
        title: Text(mainTitleApp),
      ),
      body: BodyHomeDashboard(
        people: widget.people,
      ),
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
