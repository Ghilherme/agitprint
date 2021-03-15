import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

class ListTileAdmin extends StatelessWidget {
  final ConfirmationDialog confirmationDialog;
  final String title, subtitle;
  final Function editFunction;

  const ListTileAdmin(
      {Key key,
      this.confirmationDialog,
      this.title,
      this.subtitle,
      this.editFunction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                editFunction();
              },
            ),
            IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return confirmationDialog;
                      });
                }),
          ],
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
