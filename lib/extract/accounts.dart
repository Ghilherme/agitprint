import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
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
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blue, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Extrato",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
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
            Container(
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: _buildExtract([]),
              ),
            ),
            _displayPaymentList(),
            _balance(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExtract(List<PaymentsModel> payments) {
    List<Widget> list = [];
    payments.forEach((element) {
      list.add(_paymentItems(
          "Trevello App", r"+ $ 4,946.00", "28-04-16", "credit",
          oddColour: const Color(0xFFF7F7F9)));
      list.add(new SizedBox(
        height: defaultPadding,
      ));
    });
    return list;
  }

  _displayPaymentList() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          _paymentItems("Trevello App", r"+ $ 4,946.00", "28-04-16", "credit",
              oddColour: const Color(0xFFF7F7F9)),
          _paymentItems(
              "Creative Studios", r"+ $ 5,428.00", "26-04-16", "credit"),
          _paymentItems("Amazon EU", r"+ $ 746.00", "25-04-216", "Payment",
              oddColour: const Color(0xFFF7F7F9)),
          _paymentItems(
              "Creative Studios", r"+ $ 14,526.00", "16-04-16", "Payment"),
          _paymentItems(
              "Book Hub Society", r"+ $ 2,876.00", "04-04-16", "Credit",
              oddColour: const Color(0xFFF7F7F9)),
        ],
      ),
    );
  }

  Container _paymentItems(
          String item, String charge, String dateString, String type,
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
                Text(item, style: TextStyle(fontSize: 16.0)),
                Text(charge, style: TextStyle(fontSize: 16.0))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0))
              ],
            ),
          ],
        ),
      );

  Card _balance() => Card(
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
