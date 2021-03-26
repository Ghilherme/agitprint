import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Account extends StatefulWidget {
  final PeopleModel people;

  const Account({Key key, this.people}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
          padding: EdgeInsets.all(5.0),
          // color: Color(0xFF015FFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Saldo: ',
                          style:
                              TextStyle(color: Colors.white, fontSize: 24.0)),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(r"R$ " + widget.people.balance.toString(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 24.0)),
                    ),
                  ),
                ],
              ),
            ],
          )),
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Extrato",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: AccountBody(widget.people),
    );
  }
}

class AccountBody extends StatefulWidget {
  AccountBody(this.people);
  final PeopleModel people;

  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  _AccountBodyState();

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
                height: 120.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                child: Stack(children: <Widget>[
                  Container(
                      height: 120.0,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 46.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          children: [
                            Container(height: 4),
                            Row(
                              children: [
                                Text(
                                  widget.people.name,
                                  style: GoogleTextStyles.customTextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              ],
                            ),
                            Container(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  widget.people.directorship +
                                      ' - ' +
                                      widget.people.regionalGroup,
                                  style: GoogleTextStyles.customTextStyle(
                                      fontSize: 16, color: Colors.white70),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 16.0),
                    alignment: FractionalOffset.centerLeft,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.people.imageAvatar == '' ||
                                widget.people.imageAvatar == null
                            ? Image.network(
                                    urlAvatarInitials + widget.people.name)
                                .image
                            : Image.network(widget.people.imageAvatar).image),
                  ),
                ])),
            StreamBuilder<QuerySnapshot>(
              stream: Gets.getPaymentsQuery(FirebaseFirestore.instance
                      .collection('pessoas')
                      .doc(widget.people.id))
                  .snapshots(),
              builder: (context, snapshot) {
                //Trata Load
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                //Trata Erro
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                List<PaymentsModel> pays = snapshot.data.docs
                    .map((e) => PaymentsModel.fromFirestore(e))
                    .toList();

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        children: _buildExtract(pays),
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExtract(List<PaymentsModel> payments) {
    List<Widget> list = [];

    for (int i = 0; i < payments.length; i++) {
      list.add(_paymentItems(
          payments[i].description.isEmpty
              ? 'Pagamento'
              : payments[i].description,
          r"R$ " + payments[i].amount.toString(),
          "${payments[i].createdAt.day.toString().padLeft(2, '0')}-${payments[i].createdAt.month.toString().padLeft(2, '0')}-${payments[i].createdAt.year.toString()} ${payments[i].createdAt.hour.toString().padLeft(2, '0')}:${payments[i].createdAt.minute.toString().padLeft(2, '0')}",
          payments[i].filial + ' - ' + payments[i].type,
          oddColour: i.isEven ? Colors.white : const Color(0xFFF7F7F9)));
    }

    return list;
  }

  Container _paymentItems(
          String item, String amount, String actionDate, String type,
          {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(color: oddColour),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(item,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleTextStyles.customTextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400)),
                ),
                Text(amount,
                    style: GoogleTextStyles.customTextStyle(
                        fontSize: 16,
                        color: const Color(0xff85bb65),
                        fontWeight: FontWeight.w400))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(actionDate,
                    style: GoogleTextStyles.customTextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300)),
                Text(type,
                    style: GoogleTextStyles.customTextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300))
              ],
            ),
          ],
        ),
      );

  Widget _balance() {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: Container(
          height: 70,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
          padding: EdgeInsets.all(5.0),
          // color: Color(0xFF015FFF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(r"R$ " + widget.people.balance.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 30.0)),
                ),
              ),
            ],
          )),
    );
  }
}
