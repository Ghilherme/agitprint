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
import 'package:agitprint/models/people.dart';
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
  List<DropdownMenuItem<ProvidersModel>> _itemsDropDownProvider = [];
  PeopleModel _dropdownPeople;
  List<DropdownMenuItem<PeopleModel>> _itemsDropDownPeople = [];
  String _dropdownType;
  PaymentsModel _paymentModel;
  DateTime _selectedDate = DateTime.now();

  initState() {
    super.initState();
    _getProviders();
    _paymentModel = PaymentsModel.empty();
    _paymentModel.idPeople = idPeopleLogged;
    _paymentModel.actionDate = _selectedDate;
    if (currentPeopleLogged.directorship == 'ALL') _getPeople();
  }

  void _getProviders() async {
    List<ProvidersModel> providers = currentPeopleLogged.directorship == 'ALL'
        ? await Gets.getAllActiveProviders()
        : await Gets.getProviderByDirectorship(
            currentPeopleLogged.directorship, Status.active);
    if (this.mounted) {
      setState(() {
        _itemsDropDownProvider = providers
            .map((val) => DropdownMenuItem<ProvidersModel>(
                  child: Text(displayProvider(val)),
                  value: val,
                ))
            .toList();
      });
    }
  }

  void _getPeople() async {
    List<PeopleModel> people = await Gets.getAllActivePeople();
    if (this.mounted) {
      setState(() {
        _itemsDropDownPeople = people
            .map((val) => DropdownMenuItem<PeopleModel>(
                  child: Text(val.name + ' - ' + val.directorship),
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

    if (currentPeopleLogged.directorship == 'ALL')
      strBuild += ' - ' + provider.directorship;
    return strBuild;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _paymentModel.actionDate = picked;
        _selectedDate = picked;
      });
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
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: _buildForm(),
              ),
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
          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
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
            items: _itemsDropDownProvider,
            style: GoogleTextStyles.customTextStyle(),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        _dropdownProvider == null
            ? Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
                child: BankCardBlank(
                  isAdd: false,
                ),
              )
            : Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
                child: SizedBox(
                  height: 201,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _dropdownProvider.banks.length,
                      itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(right: 5),
                          child:
                              BankCard(bank: _dropdownProvider.banks[index]))),
                ),
              ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
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
        Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
          child: CustomTextFormField(
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
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
          child: CustomTextFormField(
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              labelText: "Descrição da ação/compra",
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
        ),
        SizedBox(
          height: defaultPadding,
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Data da ação:   ' +
              "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year.toString()}"),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        currentPeopleLogged.directorship == 'ALL'
            ? Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: DropdownButtonFormField<PeopleModel>(
                  isExpanded: true,
                  itemHeight: 70,
                  hint: Text('Pessoa'),
                  value: _dropdownPeople,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  onChanged: (PeopleModel newValue) {
                    _paymentModel.idPeople = FirebaseFirestore.instance
                        .collection('pessoas')
                        .doc(newValue.id);
                    setState(() {
                      _dropdownPeople = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Campo obrigatório' : null,
                  items: _itemsDropDownPeople,
                  style: GoogleTextStyles.customTextStyle(),
                ),
              )
            : Container(),
        currentPeopleLogged.directorship == 'ALL'
            ? SizedBox(
                height: defaultPadding,
              )
            : Container(),
        Container(
          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
          child: CustomTextFormField(
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
        ),
        SizedBox(
          height: defaultPadding,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        StatefulBuilder(
            builder: (BuildContext context, StateSetter buttonState) {
          return Container(
              width: 180,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 10, color: const Color(0xFFD6D7FB))
              ]),
              child: _progressBarActive
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : CustomButton(
                      title: "Solicitar",
                      elevation: 8,
                      textStyle: theme.textTheme.subtitle2.copyWith(
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
                          await requestPayment();
                          buttonState(() {
                            _progressBarActive = false;
                          });
                        }
                      },
                    ));
        }),
        SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }

  Future<void> requestPayment() async {
    if (_paymentModel.createdAt == null)
      _paymentModel.createdAt = DateTime.now();

    //Solicitação inicia sempre como pendente
    _paymentModel.status = Status.pending;

    //sempre debito quando passa por essa tela
    _paymentModel.amount = _paymentModel.amount.isNegative
        ? _paymentModel.amount
        : -_paymentModel.amount;

    await Sets.setBalanceTransaction(_paymentModel, true)
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
        .catchError((error) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Falha ao solicitar Pagamento.'),
                  content: Text('Erro: ' + error.toString()),
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
            ));
  }
}
