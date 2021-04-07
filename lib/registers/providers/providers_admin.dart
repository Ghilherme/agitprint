import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/components/bank_card.dart';
import 'package:agitprint/components/bank_card_blank.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/field_validators.dart';
import 'package:agitprint/constants.dart';
import 'package:agitprint/models/bank_accounts.dart';
import 'package:agitprint/models/providers.dart';
import 'package:agitprint/models/status.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class ProvidersAdmin extends StatelessWidget {
  final ProvidersModel providers;

  const ProvidersAdmin({Key key, this.providers}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Administrar Fornecedores'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: ProvidersAdminBody(providers),
    );
  }
}

class ProvidersAdminBody extends StatefulWidget {
  ProvidersAdminBody(this.providers);
  final ProvidersModel providers;

  @override
  _ProvidersAdminBodyState createState() =>
      _ProvidersAdminBodyState(this.providers);
}

class _ProvidersAdminBodyState extends State<ProvidersAdminBody> {
  _ProvidersAdminBodyState(this.providers);
  final ProvidersModel providers;

  final _form = GlobalKey<FormState>();
  ProvidersModel _providersModel;
  bool _progressBarActive = false;
  List<DropdownMenuItem<String>> _itemsDropDown = [];
  List<MultiSelectItem> _itemsMultiSelect = [];
  String _dropdownDirectorship;

  initState() {
    super.initState();
    _getDirectorships();
    _getCategories();
    _providersModel = ProvidersModel.fromProviders(providers);
    if (_providersModel.directorship.isNotEmpty) {
      _dropdownDirectorship = _providersModel.directorship;
    }
    if (_providersModel.lastModification == null)
      _providersModel.lastModification = DateTime.now();
  }

  void _getDirectorships() async {
    List<String> directorships = await Gets.getDirectorships();
    if (this.mounted) {
      setState(() {
        if (currentPeopleLogged.directorship == 'ALL') {
          _itemsDropDown = directorships
              .map((dir) => DropdownMenuItem<String>(
                    child: Text(dir),
                    value: dir,
                  ))
              .toList();

          _itemsDropDown.add(DropdownMenuItem<String>(
            child: Text('Administrador'),
            value: 'ALL',
          ));
        } else
          _itemsDropDown.add(DropdownMenuItem<String>(
            child: Text(currentPeopleLogged.directorship),
            value: currentPeopleLogged.directorship,
          ));
      });
    }
  }

  Future<void> _getCategories() async {
    List<String> categories = await Gets.getCategories();
    if (this.mounted) {
      setState(() {
        _itemsMultiSelect = categories
            .map((cate) => MultiSelectItem<String>(cate, cate))
            .toList();
      });
    }
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
    return Column(
      children: <Widget>[
        Container(height: 30),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          labelText: "Nome",
          initialValue: _providersModel.name,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
          onChanged: (value) {
            _providersModel.name = value.trim();
          },
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          labelText: "CPF/CNPJ",
          initialValue: _providersModel.cpf == "" && _providersModel.cnpj == ""
              ? ""
              : _providersModel.cpf == ""
                  ? CNPJ.format(_providersModel.cnpj)
                  : CPF.format(_providersModel.cpf),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfOuCnpjFormatter()
          ],
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
          onChanged: (value) {
            _providersModel.cpf = value.trim();
            _providersModel.cnpj = value.trim();
          },
          validator: (value) {
            if (value.isEmpty) return 'Campo obrigatório';

            if (CPF.isValid(_providersModel.cpf)) {
              _providersModel.cnpj = '';
              return null;
            }

            if (CNPJ.isValid(_providersModel.cnpj)) {
              _providersModel.cpf = '';
              return null;
            }

            return 'Campo inválido';
          },
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter dropDownState) {
            return DropdownButtonFormField<String>(
              isExpanded: true,
              hint: Text('Diretoria'),
              value: _dropdownDirectorship,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
              onChanged: (String newValue) {
                _providersModel.directorship = newValue;
                dropDownState(() {
                  _dropdownDirectorship = newValue;
                });
              },
              items: _itemsDropDown,
              style: GoogleTextStyles.customTextStyle(),
            );
          }),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: MultiSelectDialogField(
              initialValue: _providersModel.categories,
              items: _itemsMultiSelect.isEmpty
                  ? _providersModel.categories
                      .map((prestador) =>
                          MultiSelectItem<String>(prestador, prestador))
                      .toList()
                  : _itemsMultiSelect,
              searchHintStyle: GoogleTextStyles.customTextStyle(),
              searchTextStyle: GoogleTextStyles.customTextStyle(),
              itemsTextStyle: GoogleTextStyles.customTextStyle(),
              title: Text('Categorias do Fornecedor'),
              listType: MultiSelectListType.CHIP,
              buttonText:
                  Text('Categorias', style: GoogleTextStyles.customTextStyle()),
              onConfirm: (results) => _providersModel.categories = results,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Column(
          children: _buildCards(_providersModel.banks),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        BankCardBlank(callback: callbackBankCardBlank),
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
                    title: "Salvar",
                    elevation: 8,
                    textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
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
                        await saveProvider();
                        buttonState(() {
                          _progressBarActive = false;
                        });
                      }
                    },
                  ),
          );
        }),
        SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }

  List<Widget> _buildCards(List<BankAccountModel> banks) {
    List<Widget> list = [];
    banks.forEach((element) {
      list.add(new BankCard(
          isEditable: true, bank: element, callback: callbackBankCard));
      list.add(new SizedBox(
        height: defaultPadding,
      ));
    });
    return list;
  }

  callbackBankCard(bank) {
    setState(() {
      _providersModel.banks.remove(bank);
      if (_providersModel.banks.length == 0)
        _providersModel.banks.add(BankAccountModel.empty());
    });
  }

  callbackBankCardBlank() {
    setState(() {
      _providersModel.banks.add(new BankAccountModel.empty());
    });
  }

  Future<void> saveProvider() async {
    if (_providersModel.createdAt == null)
      _providersModel.createdAt = DateTime.now();

    _providersModel.lastModification = DateTime.now();

    //Criado pela area administrativa é sempre ativo
    _providersModel.status = Status.active;

    //monta as contas do fornecedor
    List<dynamic> _bankAccounts = [];
    _providersModel.banks.forEach((element) {
      _bankAccounts.add({
        'codbanco': element.bankCod,
        'banco': element.bank,
        'agencia': element.agency,
        'conta': element.account,
        'contapoupanca': element.savingAccount,
        'pix': {
          'cpf': FieldValidators.removeCaracteres(element.pix['cpf']),
          'cnpj': FieldValidators.removeCaracteres(element.pix['cnpj']),
          'telefone': element.pix['telefone'],
          'email': element.pix['email'],
        },
      });
    });

    //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
    DocumentReference refDB = FirebaseFirestore.instance
        .collection('fornecedores')
        .doc(_providersModel.id);

    await refDB
        .set({
          'nome': _providersModel.name,
          'cpf': FieldValidators.removeCaracteres(_providersModel.cpf),
          'cnpj': FieldValidators.removeCaracteres(_providersModel.cnpj),
          'diretoria': _providersModel.directorship,
          'categorias': _providersModel.categories,
          'contas': _bankAccounts,
          'atualizacao': _providersModel.lastModification,
          'criacao': _providersModel.createdAt,
          'status': _providersModel.status,
        })
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                _providersModel.id = refDB.id;
                return AlertDialog(
                  title: _providersModel.id == null
                      ? Text('Fornecedor adicionado com sucesso.')
                      : Text('Fornecedor atualizado com sucesso.'),
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
                  title: _providersModel.id == null
                      ? Text('Falha ao adicionar Fornecedor.')
                      : Text('Falha ao atualizar Fornecedor.'),
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
            ));
  }
}
