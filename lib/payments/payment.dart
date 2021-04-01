import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/apis/sets.dart';
import 'package:agitprint/components/bank_card.dart';
import 'package:agitprint/components/bank_card_blank.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/field_validators.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/providers.dart';
import 'package:agitprint/models/status.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class Payment extends StatelessWidget {
  const Payment({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Solicitar Pagamento'),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: PaymentBody(),
    );
  }
}

class PaymentBody extends StatefulWidget {
  PaymentBody();

  @override
  _PaymentBodyState createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  _PaymentBodyState();

  final _form = GlobalKey<FormState>();
  bool _progressBarActive = false;
  ProvidersModel _dropdownProvider;
  List<DropdownMenuItem<ProvidersModel>> _itemsDropDown = [];
  String _dropdownType;
  PaymentsModel _paymentModel;

  initState() {
    super.initState();
    _getProviders();
    _paymentModel = PaymentsModel.empty();
    _paymentModel.idPeople = idPeopleLogged;
  }

  void _getProviders() async {
    List<ProvidersModel> providers = await Gets.getProviders();
    if (this.mounted) {
      setState(() {
        _itemsDropDown = providers
            .map((val) => DropdownMenuItem<ProvidersModel>(
                  child: Text(displayProvider(val)),
                  value: val,
                ))
            .toList();
      });
    }
  }

  String displayProvider(ProvidersModel provider) {
    String strBuild = provider.name + ' - ';
    if (provider.cnpj.isNotEmpty)
      strBuild += FieldValidators.obterCnpj(provider.cnpj);

    if (provider.cpf.isNotEmpty)
      strBuild += FieldValidators.obterCpf(provider.cpf);

    if (provider.categories.first.isNotEmpty)
      strBuild += ' (' + provider.categories.first + ')';
    return strBuild;
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: heightOfScreen * 0.45,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: DropdownButtonFormField<ProvidersModel>(
            isExpanded: true,
            itemHeight: 70,
            hint: Text('Fornecedores'),
            value: _dropdownProvider,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (ProvidersModel newValue) {
              _paymentModel.providerName = newValue.name;
              _paymentModel.idProvider = FirebaseFirestore.instance
                  .collection('fornecedores')
                  .doc(newValue.id);
              setState(() {
                _dropdownProvider = newValue;
              });
            },
            validator: (value) => value == null ? 'Campo obrigatório' : null,
            items: _itemsDropDown,
            style: GoogleTextStyles.customTextStyle(),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        _dropdownProvider == null
            ? BankCardBlank(
                isAdd: false,
              )
            : SizedBox(
                height: 201,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dropdownProvider.banks.length,
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: BankCard(bank: _dropdownProvider.banks[index]))),
              ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text('Tipo da solicitação'),
            value: _dropdownType,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (String newValue) {
              _paymentModel.type = newValue;
              setState(() {
                _dropdownType = newValue;
              });
            },
            validator: (value) => value == null ? 'Campo obrigatório' : null,
            items: paymentType.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            style: GoogleTextStyles.customTextStyle(),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            labelText: "Filial",
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
              _paymentModel.filial = value.trim();
            }),
        SizedBox(
          height: defaultPadding,
        ),
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
              _paymentModel.description = value.trim();
            }),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            RealInputFormatter(centavos: true),
          ],
          labelText: "R\$",
          initialValue: '',
          hintText: '0,00',
          border: Borders.customOutlineInputBorder(width: 2),
          enabledBorder: Borders.customOutlineInputBorder(width: 2),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(fontSize: 24),
          hintTextStyle: GoogleTextStyles.customTextStyle(fontSize: 24),
          textStyle: GoogleTextStyles.customTextStyle(fontSize: 24),
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
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          width: 180,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(blurRadius: 10, color: const Color(0xFFD6D7FB))
          ]),
          child: CustomButton(
            title: _progressBarActive == true ? null : "Solicitar",
            elevation: 8,
            textStyle: theme.textTheme.subtitle2.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
            color: AppColors.blue,
            height: 40,
            onPressed: () {
              requestPayment();
            },
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }

  void requestPayment() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });

      if (_paymentModel.createdAt == null)
        _paymentModel.createdAt = DateTime.now();

      if (_paymentModel.actionDate == null)
        _paymentModel.actionDate = DateTime.now();

      //Solicitação inicia sempre como pendente
      _paymentModel.status = Status.pending;

      //sempre debito quando passa por essa tela
      _paymentModel.amount = _paymentModel.amount.isNegative
          ? _paymentModel.amount
          : -_paymentModel.amount;

      Sets.setBalanceTransaction(_paymentModel, true)
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pagamento solicitado com sucesso.'),
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
              }))
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Falha ao solicitar Pagamento.'),
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
}
