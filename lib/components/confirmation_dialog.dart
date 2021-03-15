import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title, content;
  final Function okFunction;

  const ConfirmationDialog({Key key, this.title, this.content, this.okFunction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              okFunction();
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
