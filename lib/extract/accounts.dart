import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/apis/sets.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/people.dart';
import 'package:agitprint/models/status.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class Account extends StatefulWidget {
  final PeopleModel people;

  const Account({Key key, this.people}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _progressBarActive = false;
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _buildBalance(),
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

  buildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        PaymentsModel _paymentModel = PaymentsModel.empty();
        return Form(
          key: _form,
          child: SimpleDialog(
            title: Text('Acrescentar saldo:'),
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    CustomTextFormField(
                        textInputType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        labelText: "Descrição",
                        initialValue: '',
                        border: Borders.customOutlineInputBorder(),
                        enabledBorder: Borders.customOutlineInputBorder(),
                        focusedBorder: Borders.customOutlineInputBorder(
                          color: const Color(0xFF655796),
                        ),
                        labelStyle: GoogleTextStyles.customTextStyle(),
                        hintTextStyle: GoogleTextStyles.customTextStyle(),
                        textStyle: GoogleTextStyles.customTextStyle(),
                        onChanged: (value) {
                          _paymentModel.description = value;
                        }),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormField(
                        textInputType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        labelText: r"R$",
                        initialValue: '',
                        border: Borders.customOutlineInputBorder(),
                        enabledBorder: Borders.customOutlineInputBorder(),
                        focusedBorder: Borders.customOutlineInputBorder(
                          color: const Color(0xFF655796),
                        ),
                        labelStyle: GoogleTextStyles.customTextStyle(),
                        hintTextStyle: GoogleTextStyles.customTextStyle(),
                        textStyle: GoogleTextStyles.customTextStyle(),
                        onChanged: (value) {
                          _paymentModel.amount =
                              UtilBrasilFields.converterMoedaParaDouble(value);
                        }),
                    SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                ),
              ),
              Center(
                  child: ElevatedButton(
                      child: Text('Adicionar'),
                      onPressed: () {
                        updateBalance(_paymentModel);
                        Navigator.of(context).pop();
                      }))
            ],
            contentPadding: const EdgeInsets.all(defaultPadding),
          ),
        );
      },
    );
  }

  void updateBalance(PaymentsModel _paymentModel) async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });

      if (_paymentModel.createdAt == null)
        _paymentModel.createdAt = DateTime.now();

      if (_paymentModel.actionDate == null)
        _paymentModel.actionDate = DateTime.now();

      //Solicitação inicia sempre como ativa
      _paymentModel.status = Status.active;

      _paymentModel.type =
          _paymentModel.amount.isNegative ? 'Débito' : 'Crédito';

      //referencia id da atual pessoa desse extrato
      _paymentModel.idPeople = FirebaseFirestore.instance
          .collection('pessoas')
          .doc(widget.people.id);
      //referencia admin como fornecedor
      _paymentModel.idProvider = FirebaseFirestore.instance
          .collection('fornecedores')
          .doc(fazerLogar.id);

      Sets.setBalanceTransaction(_paymentModel, false)
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Saldo atualizado com sucesso.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ))
          .then((value) => setState(() {
                _progressBarActive = false;
                widget.people.balance =
                    widget.people.balance + _paymentModel.amount;
              }))
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Falha ao atualizar saldo.'),
                    content: Text('Erro: ' + error),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ))
          .then((value) => setState(() {
                _progressBarActive = false;
              }));
    }
  }

  Card _buildBalance() {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 11.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      child: Container(
          height: 70,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
          padding: EdgeInsets.all(5.0),
          // color: Color(0xFF015FFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add_circle_sharp,
                  size: 30,
                ),
                onPressed: () => buildDialog(context),
                color: Colors.blueGrey[100],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(r"R$ " + widget.people.balance.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                ),
              ),
            ],
          )),
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
          payments[i].amount,
          "${payments[i].createdAt.day.toString().padLeft(2, '0')}-${payments[i].createdAt.month.toString().padLeft(2, '0')}-${payments[i].createdAt.year.toString()} ${payments[i].createdAt.hour.toString().padLeft(2, '0')}:${payments[i].createdAt.minute.toString().padLeft(2, '0')}",
          payments[i].filial + ' - ' + payments[i].type,
          oddColour: i.isEven ? Colors.white : const Color(0xFFF7F7F9)));
    }

    return list;
  }

  Container _paymentItems(
          String item, num amount, String actionDate, String type,
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
                amount.isNegative
                    ? Text(r"R$ " + amount.toString(),
                        style: GoogleTextStyles.customTextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w400))
                    : Text(r"R$ " + amount.toString(),
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
}
