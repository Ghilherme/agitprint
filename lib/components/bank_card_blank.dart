import 'package:flutter/material.dart';

class BankCardBlank extends StatelessWidget {
  BankCardBlank({Key key, this.callback, this.isAdd = true}) : super(key: key);

  final Function callback;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Material(
        elevation: 1,
        shadowColor: Colors.grey.shade300,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(children: [
          Container(
              width: _media.width - 40,
              height: 201,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: isAdd
                        ? IconButton(
                            icon: Icon(Icons.add),
                            iconSize: 40,
                            onPressed: () {
                              callback();
                            },
                          )
                        : Container(),
                  )
                ],
              )),
        ]));
  }
}
