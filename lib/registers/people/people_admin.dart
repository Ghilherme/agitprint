import 'dart:io';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/image_picker.dart';
import 'package:agitprint/constants.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PeopleAdmin extends StatelessWidget {
  final PeopleModel people;

  const PeopleAdmin({Key key, this.people}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Administrar Pessoas'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: PeopleAdminBody(people),
    );
  }
}

class PeopleAdminBody extends StatefulWidget {
  PeopleAdminBody(this.people);
  final PeopleModel people;

  @override
  _PeopleAdminBodyState createState() => _PeopleAdminBodyState(this.people);
}

class _PeopleAdminBodyState extends State<PeopleAdminBody> {
  _PeopleAdminBodyState(this.people);
  final PeopleModel people;

  final _form = GlobalKey<FormState>();
  PeopleModel _peopleModel;
  bool _progressBarActive = false;
  String _fileAvatarUpload = '';

  initState() {
    super.initState();
    _peopleModel = PeopleModel.fromPeople(people);
    displayProfiles();

    if (_peopleModel.lastModification == null)
      _peopleModel.lastModification = DateTime.now();
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

  List<MultiSelectItem> _items = profiles;

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(height: 30),
        Center(
          child: ImagePickerSource(
            image: _peopleModel.imageAvatar,
            callback: callbackAvatar,
            isAvatar: true,
            imageQuality: 35,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.text,
          labelText: "Nome",
          initialValue: _peopleModel.name,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.emailAddress,
          labelText: "Email",
          initialValue: _peopleModel.email,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: AppColors.violetShade200,
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.visiblePassword,
          labelText: "Senha",
          initialValue: _peopleModel.password,
          hasSuffixIcon: true,
          suffixIcon: Icon(
            Icons.lock,
            color: AppColors.blackShade10,
          ),
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: AppColors.violetShade200,
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.emailAddress,
          labelText: "Diretoria",
          initialValue: _peopleModel.directorship,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: AppColors.violetShade200,
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
          textInputType: TextInputType.emailAddress,
          labelText: "Regional",
          initialValue: _peopleModel.regionalGroup,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: AppColors.violetShade200,
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
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
              initialValue: _peopleModel.profiles,
              items: _items.isEmpty
                  ? _peopleModel.profiles
                      .map((profiles) =>
                          MultiSelectItem<String>(profiles, profiles))
                      .toList()
                  : _items,
              searchHintStyle: GoogleTextStyles.customTextStyle(),
              searchTextStyle: GoogleTextStyles.customTextStyle(),
              itemsTextStyle: GoogleTextStyles.customTextStyle(),
              title: Text('Perfis de acesso'),
              listType: MultiSelectListType.CHIP,
              buttonText: Text('Perfis',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              onConfirm: (results) => _peopleModel.profiles = results,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null),
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
            title: "Salvar",
            elevation: 8,
            textStyle: theme.textTheme.subtitle2.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
            color: AppColors.blue,
            height: 40,
            onPressed: () {
              saveContact();
            },
          ),
        )
      ],
    );
  }

  callbackAvatar(file) {
    setState(() {
      _fileAvatarUpload = file;
    });
  }

  Future<String> uploadFileImage(String refPath, String filePath) async {
    File file = File(filePath);

    await FirebaseStorage.instance.ref(refPath).putFile(file);
    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }

  void saveContact() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });

      //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
      DocumentReference contactDB =
          FirebaseFirestore.instance.collection('pessoas').doc(_peopleModel.id);

      //Se houve alteração na imagem, faz um novo upload
      if (_fileAvatarUpload.isNotEmpty)
        _peopleModel.imageAvatar = await uploadFileImage(
            'uploads/' + contactDB.id + '/' + contactDB.id + '_avatar.png',
            _fileAvatarUpload);

      if (_peopleModel.createdAt == null)
        _peopleModel.createdAt = DateTime.now();

      _peopleModel.lastModification = DateTime.now();

      contactDB
          .set({
            'nome': _peopleModel.name,
            'email': _peopleModel.email,
            'login': _peopleModel.login,
            'senha': _peopleModel.password,
            'saldo': _peopleModel.balance,
            'perfil': _peopleModel.profiles,
            'diretoria': _peopleModel.directorship,
            'regional': _peopleModel.regionalGroup,
            'pagamentospendentes': _peopleModel.pendingPayments,
            'avatar': _peopleModel.imageAvatar,
            'atualizacao': _peopleModel.lastModification,
            'criacao': _peopleModel.createdAt,
            'status': _peopleModel.status,
          })
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _peopleModel.id == null
                        ? Text('Pessoa adicionada com sucesso.')
                        : Text('Pessoa atualizada com sucesso.'),
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
                _peopleModel.id = contactDB.id;
              }))
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _peopleModel.id == null
                        ? Text('Falha ao adicionar Pessoa.')
                        : Text('Falha ao atualizar Pessoa.'),
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

  Future<void> displayProfiles() async {
    setState(() {
      _items = _peopleModel.profiles
          .map((prestador) => MultiSelectItem<String>(prestador, prestador))
          .toList();
    });
  }
}
