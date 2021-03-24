import 'package:agitprint/models/people.dart';
import 'package:agitprint/models/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../extract/accounts.dart';
import '../constants.dart';

class BodyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('pessoas')
        .orderBy('nome')
        .where('status', isEqualTo: Status.active);

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
          trailing: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: people.pendingPayments.toString(),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  text: "R\$" + people.balance.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
