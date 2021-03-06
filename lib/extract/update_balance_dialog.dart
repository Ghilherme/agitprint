import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/apis/sets.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
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

class UpdateBalanceDialog extends StatefulWidget {
  final PeopleModel people;
  final Function(num) callback;
  final bool isAdd;

  const UpdateBalanceDialog(
      {Key key, this.people, this.callback, this.isAdd = true})
      : super(key: key);

  @override
  _UpdateBalanceDialogState createState() => _UpdateBalanceDialogState();
}

class _UpdateBalanceDialogState extends State<UpdateBalanceDialog> {
  bool _progressBarActive = false;
  final _form = GlobalKey<FormState>();
  PaymentsModel _paymentModel = PaymentsModel.empty();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SimpleDialog(
        title: Text(widget.isAdd ? 'Adicionar Saldo:' : 'Retirar Saldo:'),
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
                    RealInputFormatter(centavos: true)
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
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'Campo obrigatório';

                    if (value == '0,00') return 'Valor necessário';
                    return null;
                  },
                ),
                SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter buttonState) {
            return Center(
                child: _progressBarActive
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: CustomButton(
                          title: widget.isAdd ? 'Creditar' : 'Debitar',
                          elevation: 8,
                          textStyle:
                              Theme.of(context).textTheme.subtitle2.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                          color: AppColors.blue,
                          height: 40,
                          onPressed: () async {
                            if (_form.currentState.validate()) {
                              buttonState(() {
                                _progressBarActive = true;
                              });
                              await updateBalance(_paymentModel);
                              buttonState(() {
                                _progressBarActive = false;
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ));
          })
        ],
        contentPadding: const EdgeInsets.all(defaultPadding),
      ),
    );
  }

  Future<void> updateBalance(PaymentsModel _paymentModel) async {
    if (_paymentModel.createdAt == null)
      _paymentModel.createdAt = DateTime.now();

    if (_paymentModel.actionDate == null)
      _paymentModel.actionDate = DateTime.now();

    //Solicitação inicia sempre como ativa
    _paymentModel.status = Status.active;

    if (widget.isAdd) {
      _paymentModel.type = 'Crédito';
    } else {
      _paymentModel.type = 'Débito';
      _paymentModel.amount = -_paymentModel.amount;
    }

    //referencia id da atual pessoa desse extrato no qual sera feito o pagamento
    _paymentModel.idPeople =
        FirebaseFirestore.instance.collection('pessoas').doc(widget.people.id);

    //referencia o fornecedor que for admin (diretoria = ALL)
    await Gets.getProviderByDirectorship('ALL', Status.active).then((value) {
      _paymentModel.idProvider = FirebaseFirestore.instance
          .collection('fornecedores')
          .doc(value.first.id);
      _paymentModel.providerName = value.first.name;
    });

    await Sets.setBalanceTransaction(_paymentModel, false)
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
        .whenComplete(() =>
            widget.callback(widget.people.balance + _paymentModel.amount));
  }
}
