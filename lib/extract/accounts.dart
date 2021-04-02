import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/screen_size.dart';
import 'package:agitprint/constants.dart';
import 'package:agitprint/extract/transaction_tile.dart';
import 'package:agitprint/extract/update_balance_dialog.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'balance_card.dart';

class Account extends StatefulWidget {
  final PeopleModel people;

  const Account({Key key, @required this.people}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey.shade50,
            height: _media.height / 2,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: <Widget>[
                          Material(
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/bg1.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: Container(
                              color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
                Positioned(
                  top: _media.longestSide <= 775
                      ? screenAwareSize(25, context)
                      : screenAwareSize(35, context),
                  left: 10,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          /* IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => print("notification"),
                          ), */
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Extrato",
                              style: TextStyle(
                                  fontSize: _media.longestSide <= 775 ? 35 : 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Varela"),
                            ),
                          ),
                          currentPeopleLogged.profiles.contains('admin1')
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateBalanceDialog(
                                        people: widget.people,
                                        callback: callbackBalance,
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          currentPeopleLogged.profiles.contains('admin2')
                              ? IconButton(
                                  icon: Icon(
                                    Icons.remove_sharp,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateBalanceDialog(
                                        people: widget.people,
                                        callback: callbackBalance,
                                        isAdd: false,
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    height: _media.longestSide <= 775
                        ? _media.height / 4
                        : _media.height / 4.3,
                    width: _media.width,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 10),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: BalanceCard(people: widget.people),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            width: _media.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, bottom: 15, right: 10, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Tudo",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Créditos",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Débitos",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    bottom: 10,
                    top: 10,
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Gets.getPeopleStream(widget.people.id),
                      builder: (context, snapshot) {
                        //Trata Load
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: Container());

                        //Trata Erro
                        if (snapshot.hasError)
                          return Center(child: Text(snapshot.error.toString()));

                        return Text(
                          snapshot.data.get('pagamentospendentes').toString() +
                              ' pagamentos pendentes',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        );
                      }),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: Gets.getPaymentsStream(widget.people.id),
                      builder: (context, snapshot) {
                        //Trata Load
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        //Trata Erro
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        List<PaymentsModel> pays = snapshot.data.docs
                            .map((e) => PaymentsModel.fromFirestore(e))
                            .toList();

                        return ListView.separated(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 85.0),
                              child: Divider(),
                            );
                          },
                          padding: EdgeInsets.zero,
                          itemCount: pays.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TransactionTile(
                              payment: pays[index],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  callbackBalance(balance) {
    setState(() {
      widget.people.balance = balance;
    });
  }
}
