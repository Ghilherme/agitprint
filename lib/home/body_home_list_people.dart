import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/models/status.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../extract/accounts.dart';
import '../constants.dart';

class BodyHomeListPeople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query = currentPeopleLogged.directorship == 'ALL'
        ? Gets.getAllActivePeopleQuery()
        : Gets.getPeopleByDirectorshipQuery(
            currentPeopleLogged.directorship, Status.active);

    //Cria Stream com essa query
    return StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;

          return ListView.builder(
              padding: EdgeInsets.all(defaultPaddingListView),
              itemCount: querySnapshot.size,
              itemBuilder: (context, i) {
                return _buildRow(
                    context, querySnapshot.docs[i], i, querySnapshot.size);
              });
        });
  }

  Widget _buildRow(
      BuildContext context, DocumentSnapshot snapshot, int indice, int size) {
    PeopleModel people = PeopleModel.fromFirestore(snapshot);
    if (people.directorship == 'ALL') return Container();
    return Column(children: <Widget>[
      ListTile(
          //isThreeLine: true,
          leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  people.imageAvatar == '' || people.imageAvatar == null
                      ? Image.network(urlAvatarInitials + people.name).image
                      : Image.network(people.imageAvatar).image),
          subtitle: Text(people.directorship + " - " + people.regionalGroup),
          title: Text(
            people.name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color:
                      people.pendingPayments == 0 ? Colors.grey : Colors.green,
                ),
                child: Center(
                    child: Text(
                  people.pendingPayments.toString(),
                  style: GoogleTextStyles.customTextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                    NumberFormat.simpleCurrency(locale: "pt_BR")
                        .format(people.balance),
                    style: GoogleTextStyles.customTextStyle(
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Account(
                      people: people,
                    )));
          }),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
