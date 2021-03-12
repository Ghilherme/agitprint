import 'dart:io';
import 'package:agitprint/components/image_picker.dart';
import 'package:agitprint/models/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class PeopleAdmin extends StatelessWidget {
  final PeopleModel contact;

  const PeopleAdmin({Key key, this.contact}) : super(key: key);
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
      body: CreateContactBody(contact),
    );
  }
}

class CreateContactBody extends StatefulWidget {
  CreateContactBody(this.people);
  final PeopleModel people;

  @override
  _CreateContactBodyState createState() => _CreateContactBodyState(this.people);
}

class _CreateContactBodyState extends State<CreateContactBody> {
  _CreateContactBodyState(this.people);
  final PeopleModel people;

  final _form = GlobalKey<FormState>();
  PeopleModel _peopleModel;
  bool _progressBarActive = false;
  String _fileAvatarUpload = '';

  initState() {
    super.initState();

    _peopleModel = PeopleModel.fromContact(people);

    if (_peopleModel.lastModification == null)
      _peopleModel.lastModification = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            Container(height: 30),
            Center(
              child: ImagePickerSource(
                image: _peopleModel.imageAvatar,
                callback: callbackAvatar,
                isAvatar: true,
                imageQuality: 35,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: _peopleModel.name,
                onChanged: (value) {
                  _peopleModel.name = value;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Nome",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: new TextFormField(
                initialValue: _peopleModel.email,
                onChanged: (value) {
                  _peopleModel.email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            Container(height: 30),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                child: _progressBarActive == true
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text('Salvar'),
                onPressed: saveContact,
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
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
}
