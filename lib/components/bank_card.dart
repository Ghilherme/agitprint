import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/validators_utils.dart';
import 'package:agitprint/models/bank_accounts.dart';
import 'package:agitprint/models/banks.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'borders.dart';
import 'colors.dart';
import 'custom_text_form_field.dart';

class BankCard extends StatefulWidget {
  BankCard(
      {Key key, @required this.bank, this.isEditable = false, this.callback})
      : super(key: key);
  BankAccountModel bank;
  bool isEditable;
  final Function(BankAccountModel) callback;

  @override
  _BankCardState createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  BankAccountModel _bank = BankAccountModel.empty();
  BankModel _dropdownBanks;
  List<DropdownMenuItem<BankModel>> _itemsDropDown = [];

  initState() {
    super.initState();
    getBanks();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    if (widget.bank != null)
      _bank = BankAccountModel.fromBankAccount(widget.bank);

    if (widget.bank.bankCod.isNotEmpty && _itemsDropDown.length != 0)
      _dropdownBanks = _itemsDropDown
          .where((element) => element.value.bankCod == widget.bank.bankCod)
          .first
          .value;
    return Material(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          widget.isEditable
              ? Positioned(
                  top: 60,
                  right: -5,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => buildDialog(context),
                    ),
                  ))
              : Container(),
          widget.isEditable
              ? Positioned(
                  bottom: 20,
                  right: -5,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => buildDialogPix(context),
                    ),
                  ),
                )
              : Container(),
          widget.isEditable
              ? Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.callback(widget.bank);
                          widget.bank = null;
                          widget.isEditable = false;
                        });
                      },
                    ),
                  ),
                )
              : Container(),
          Positioned(
            top: 15,
            left: 30,
            child: Container(
              padding: EdgeInsets.all(0),
              child: Text(
                _bank.bankCod,
                style: GoogleTextStyles.customTextStyle(),
              ),
            ),
          ),
          Container(
            height: 201,
            width: _media.width - 40,
            padding: EdgeInsets.only(right: 30, top: 30, left: 30, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text(
                  _bank.bank == '' ? 'Banco' : _bank.bank,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Agencia: " + _bank.agency,
                    style: GoogleTextStyles.customTextStyle()),
                SizedBox(height: 10),
                Text(
                  _bank.savingAccount.isEmpty
                      ? "Conta Corrente: " + _bank.account
                      : "Conta Poupança: " + _bank.savingAccount,
                  style: GoogleTextStyles.customTextStyle(),
                ),
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("PIX:",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: AppColors.blackShade3,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _bank.pix['cpf'] == ""
                                ? Container()
                                : Text(
                                    'CPF: ' +
                                        ValidatorUtils.obterCpf(
                                            _bank.pix['cpf']),
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            _bank.pix['cnpj'] == ""
                                ? Container()
                                : Text(
                                    'CNPJ: ' +
                                        ValidatorUtils.obterCnpj(
                                            _bank.pix['cnpj']),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            _bank.pix['telefone'] == ""
                                ? Container()
                                : Text(
                                    'Telefone: ' +
                                        ValidatorUtils.obterTelefone(
                                            _bank.pix['telefone']),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ],
                        ),
                        Row(
                          children: [
                            _bank.pix['email'] == ""
                                ? Container()
                                : Text(
                                    'Email: ' + _bank.pix['email'],
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              height: 23,
              width: 50,
              child: _getBankLogo(_bank.bankCod),
            ),
          ),
        ],
      ),
    );
  }

  Image _getBankLogo(String bankCod) {
    String bankAsset = '';
    switch (bankCod) {
      case '001':
        bankAsset = 'assets/images/bb_logo.jpg';
        break;
      case '033':
        bankAsset = 'assets/images/santander_logo.png';
        break;
      case '104':
        bankAsset = 'assets/images/caixa_logo.jpg';
        break;
      case '237':
        bankAsset = 'assets/images/bradesco_logo.png';
        break;
      case '029':
      case '341':
        bankAsset = 'assets/images/itau_logo.jpg';
        break;

      default:
        bankAsset = 'assets/images/bank_logo.png';
    }

    return Image(
        image: Image.asset(
      bankAsset,
      width: 50,
      color: Colors.white,
    ).image);
  }

  buildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Dados Bancários'),
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  StatefulBuilder(builder:
                      (BuildContext context, StateSetter dropDownState) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: DropdownButton<BankModel>(
                        isExpanded: true,
                        hint: Text('Bancos'),
                        value: _dropdownBanks,
                        itemHeight: 70,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (newValue) {
                          dropDownState(() {
                            _bank.bankCod = newValue.bankCod;
                            _bank.bank = newValue.name;
                            _dropdownBanks = newValue;
                          });
                        },
                        items: _itemsDropDown,
                        style: GoogleTextStyles.customTextStyle(),
                      ),
                    );
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
                      labelText: "Agencia",
                      initialValue: _bank.agency,
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.agency = value.trim();
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
                      labelText: "Conta Corrente",
                      initialValue: _bank.account,
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.account = value.trim();
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
                      labelText: "Conta Poupança",
                      initialValue: _bank.savingAccount,
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.savingAccount = value.trim();
                      }),
                  SizedBox(
                    height: defaultPadding,
                  )
                ],
              ),
            ),
            Center(
                child: ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        _updateWidget();
                      });
                      Navigator.of(context).pop();
                    }))
          ],
          contentPadding: const EdgeInsets.all(defaultPadding),
        );
      },
    );
  }

  buildDialogPix(BuildContext context) {
    String _telefone = ValidatorUtils.obterTelefone(_bank.pix['telefone']);

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('PIX'),
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  CustomTextFormField(
                      textInputType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfOuCnpjFormatter()
                      ],
                      labelText: "CPF/CNPJ",
                      initialValue:
                          _bank.pix['cpf'] == "" && _bank.pix['cnpj'] == ""
                              ? ""
                              : _bank.pix['cpf'] == ""
                                  ? CNPJ.format(_bank.pix['cnpj'])
                                  : CPF.format(_bank.pix['cpf']),
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _bank.pix['cpf'] = '';
                          _bank.pix['cnpj'] = '';
                        }
                        if (CPF.isValid(value)) {
                          _bank.pix['cpf'] = value.trim();
                          _bank.pix['cnpj'] = '';
                        }

                        if (CNPJ.isValid(value)) {
                          _bank.pix['cnpj'] = value.trim();
                          _bank.pix['cpf'] = '';
                        }
                      }),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  CustomTextFormField(
                      textInputType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                      labelText: "Telefone",
                      initialValue: _telefone,
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.pix['telefone'] =
                            ValidatorUtils.extrairTelefone(value.trim());
                      }),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  CustomTextFormField(
                      textInputType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      labelText: "Email",
                      initialValue: _bank.pix['email'],
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.pix['email'] = (value).trim();
                      }),
                  SizedBox(
                    height: defaultPadding,
                  )
                ],
              ),
            ),
            Center(
                child: ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        _updateWidget();
                      });
                      Navigator.of(context).pop();
                    }))
          ],
          contentPadding: const EdgeInsets.all(defaultPadding),
        );
      },
    );
  }

  void getBanks() async {
    List<BankModel> _banks = await Gets.readBankJson();
    if (this.mounted) {
      setState(() {
        _itemsDropDown =
            _banks.map<DropdownMenuItem<BankModel>>((BankModel value) {
          return DropdownMenuItem<BankModel>(
            value: value,
            child: Text(value.bankCod + ' - ' + value.name),
          );
        }).toList();
      });
    }
  }

  void _updateWidget() {
    widget.bank.bankCod = _bank.bankCod;
    widget.bank.bank = _bank.bank;
    widget.bank.agency = _bank.agency;
    widget.bank.account = _bank.account;
    widget.bank.savingAccount = _bank.savingAccount;
    widget.bank.pix = _bank.pix;
  }
}
