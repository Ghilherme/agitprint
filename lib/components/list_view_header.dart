import 'package:flutter/material.dart';

import '../constants.dart';

class ListViewHeader extends StatelessWidget {
  final String title;

  const ListViewHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          Container(height: 10)
        ],
      ),
    );
  }
}
