import 'package:agitprint/components/confirmation_dialog.dart';
import 'package:agitprint/components/list_tile_admin.dart';
import 'package:agitprint/components/list_view_header.dart';
import 'package:agitprint/models/directorship.dart';
import 'package:agitprint/registers/directorship/directorship_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ListDirectorshipAdmin extends StatelessWidget {
  const ListDirectorshipAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('diretorias').orderBy('nome');

    return Scaffold(
        appBar: AppBar(
            title: Text("Diretorias"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DirectorshipAdmin(
                              directories: DirectorshipModel.empty(),
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
        title: size.toString() + ' Diretorias no total',
      );

    index -= 1;
    DirectorshipModel directorship =
        DirectorshipModel.fromFirestore(snapshot[index]);

    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Diretoria: ' + directorship.name,
          okFunction: () {
            FirebaseFirestore.instance
                .collection('diretorias')
                .doc(directorship.id)
                .delete();
          },
          title: 'Deseja excluir a diretoria?',
        ),
        title: directorship.name,
        subtitle: directorship.description,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DirectorshipAdmin(directories: directorship)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
