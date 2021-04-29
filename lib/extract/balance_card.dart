import 'package:agitprint/models/people.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class BalanceCard extends StatelessWidget {
  BalanceCard({Key key, this.people}) : super(key: key);
  final PeopleModel people;

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
      child: Stack(
        children: <Widget>[
          Container(
            width: _media.width - 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  people.name,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  NumberFormat.simpleCurrency(locale: "pt_BR")
                      .format(people.balance),
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: people.balance.isNegative
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      people.regionalGroup.isEmpty
                          ? people.directorship
                          : people.directorship + ' - ' + people.regionalGroup,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    /* Text('22/22',
                        style: Theme.of(context).textTheme.headline.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            )) */
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    people.imageAvatar == '' || people.imageAvatar == null
                        ? Image.network(urlAvatarInitials + people.name).image
                        : Image.network(people.imageAvatar).image),
          ),
        ],
      ),
    );
  }
}
