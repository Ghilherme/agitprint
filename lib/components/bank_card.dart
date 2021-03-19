import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/validators_utils.dart';
import 'package:agitprint/models/bank_accounts.dart';
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
  BankCard({Key key, @required this.bank, this.isEditable = false})
      : super(key: key);
  BankAccountModel bank;
  final bool isEditable;

  @override
  _BankCardState createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  BankAccountModel _bank = BankAccountModel.empty();

  initState() {
    super.initState();
    _bank = BankAccountModel.fromBankAccount(widget.bank);
  }

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
          widget.isEditable
              ? Positioned(
                  top: 50,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => buildDialog(context),
                    ),
                  ))
              : Container(),
          widget.isEditable
              ? Positioned(
                  bottom: 20,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => buildDialogPix(context),
                    ),
                  ))
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
            width: _media.width - 40,
            padding: EdgeInsets.all(30),
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
                                : Text('Email: ' + _bank.pix['email'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    )),
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
              width: 47,
              color: Color(0xFF015FFF),
              padding: EdgeInsets.all(7),
              child: Image.network(
                'https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png',
                width: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
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
                  CustomTextFormField(
                      textInputType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      labelText: "Banco",
                      initialValue: _bank.bank,
                      border: Borders.customOutlineInputBorder(),
                      enabledBorder: Borders.customOutlineInputBorder(),
                      focusedBorder: Borders.customOutlineInputBorder(
                        color: const Color(0xFF655796),
                      ),
                      labelStyle: GoogleTextStyles.customTextStyle(),
                      hintTextStyle: GoogleTextStyles.customTextStyle(),
                      textStyle: GoogleTextStyles.customTextStyle(),
                      onChanged: (value) {
                        _bank.bank = value.trim();
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
                        widget.bank = _bank;
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
                        widget.bank = _bank;
                      });
                      Navigator.of(context).pop();
                    }))
          ],
          contentPadding: const EdgeInsets.all(defaultPadding),
        );
      },
    );
  }
}