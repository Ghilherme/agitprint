import 'package:agitprint/components/confirmation_dialog.dart';
import 'package:agitprint/components/list_tile_admin.dart';
import 'package:agitprint/components/list_view_header.dart';
import 'package:agitprint/models/categories.dart';
import 'package:agitprint/registers/categories/categories_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ListCategoriesAdmin extends StatelessWidget {
  const ListCategoriesAdmin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('categorias').orderBy('nome');

    return Scaffold(
        appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesAdmin(
                              categories: CategoriesModel.empty(),
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
        title: size.toString() + ' Categorias no total',
      );

    index -= 1;
    CategoriesModel category = CategoriesModel.fromFirestore(snapshot[index]);

    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Categoria: ' + category.name,
          okFunction: () {
            FirebaseFirestore.instance
                .collection('categorias')
                .doc(category.id)
                .delete();
          },
          title: 'Deseja excluir a categoria?',
        ),
        title: category.name,
        subtitle: category.description,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoriesAdmin(categories: category)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
