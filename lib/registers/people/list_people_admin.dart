import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/confirmation_dialog.dart';
import 'package:agitprint/components/list_tile_admin.dart';
import 'package:agitprint/components/list_view_header.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/models/status.dart';
import 'package:agitprint/registers/people/people_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ListPeopleAdmin extends StatelessWidget {
  const ListPeopleAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = currentPeopleLogged.directorship == 'ALL'
        ? Gets.getAllActivePeopleQuery()
        : Gets.getPeopleByDirectorshipQuery(
            currentPeopleLogged.directorship, Status.active);

    return Scaffold(
        appBar: AppBar(
            title: Text("Pessoas"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PeopleAdmin(
                              people: PeopleModel.empty(),
                            )));
                  })
            ],
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, stream) {
            //Trata Load
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            //Trata Erro
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
                padding: EdgeInsets.only(
                    top: defaultPaddingListView,
                    bottom: defaultPaddingListView,
                    left: defaultPaddingListView),
                itemCount:
                    querySnapshot.size == null ? 1 : querySnapshot.size + 1,
                itemBuilder: (context, i) {
                  return _buildRow(
                      context, querySnapshot.docs, i, querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, List<QueryDocumentSnapshot> snapshot,
      int index, int size) {
    if (index == 0)
      return ListViewHeader(
        title: size.toString() + ' Pessoas no total',
      );

    index -= 1;
    PeopleModel people = PeopleModel.fromFirestore(snapshot[index]);

    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Nome: ' +
              people.name +
              '\nDiretoria: ' +
              people.directorship +
              '\nRegional: ' +
              people.regionalGroup,
          okFunction: () {
            FirebaseFirestore.instance
                .collection('pessoas')
                .doc(people.id)
                .update({'status': Status.disabled});
          },
          title: 'Deseja desabilitar a conta?',
        ),
        title: people.name,
        subtitle: people.directorship +
            ' ' +
            people.regionalGroup +
            '\nCriado em: ' +
            "${people.createdAt.day.toString().padLeft(2, '0')}-${people.createdAt.month.toString().padLeft(2, '0')}-${people.createdAt.year.toString()} ${people.createdAt.hour.toString().padLeft(2, '0')}:${people.createdAt.minute.toString().padLeft(2, '0')}",
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PeopleAdmin(people: people)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
