import 'package:agitprint/components/confirmation_dialog.dart';
import 'package:agitprint/components/list_tile_admin.dart';
import 'package:agitprint/components/list_view_header.dart';
import 'package:agitprint/models/providers.dart';
import 'package:agitprint/models/status.dart';
import 'package:agitprint/registers/providers/providers_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ListProvidersAdmin extends StatelessWidget {
  const ListProvidersAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('fornecedores')
        .orderBy('nome')
        .where('status', isEqualTo: Status.active);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text("Fornecedores"),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProvidersAdmin(
                              providers: ProvidersModel.empty(),
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
        title: size.toString() + ' Fornecedores no total',
      );

    index -= 1;
    ProvidersModel providers = ProvidersModel.fromFirestore(snapshot[index]);

    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Nome: ' +
              providers.name +
              '\nDiretoria: ' +
              providers.directorship +
              '\nCategoria: ' +
              providers.categories.first,
          okFunction: () {
            FirebaseFirestore.instance
                .collection('fornecedores')
                .doc(providers.id)
                .update({'status': Status.disabled});
          },
          title: 'Deseja desabilitar o fornecedor?',
        ),
        title: providers.name,
        subtitle: providers.directorship +
            ' ' +
            providers.categories.first +
            '\nCriado em: ' +
            "${providers.createdAt.day.toString().padLeft(2, '0')}-${providers.createdAt.month.toString().padLeft(2, '0')}-${providers.createdAt.year.toString()} ${providers.createdAt.hour.toString().padLeft(2, '0')}:${providers.createdAt.minute.toString().padLeft(2, '0')}",
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProvidersAdmin(providers: providers)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
