import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/directorship.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class DirectorshipAdmin extends StatelessWidget {
  final DirectorshipModel directories;

  const DirectorshipAdmin({Key key, this.directories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Diretoria'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: DirectorshipAdminBody(directories),
    );
  }
}

class DirectorshipAdminBody extends StatefulWidget {
  DirectorshipAdminBody(this.directories);
  final DirectorshipModel directories;

  @override
  _DirectorshipAdminBodyState createState() =>
      _DirectorshipAdminBodyState(this.directories);
}

class _DirectorshipAdminBodyState extends State<DirectorshipAdminBody> {
  _DirectorshipAdminBodyState(this.directories);
  final DirectorshipModel directories;

  final _form = GlobalKey<FormState>();
  DirectorshipModel _directoriesModel;
  bool _progressBarActive = false;

  initState() {
    super.initState();

    _directoriesModel = DirectorshipModel.fromDirectories(directories);
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
          height: 30,
        ),
        CustomTextFormField(
          textInputType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Título",
          initialValue: _directoriesModel.name,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
          onChanged: (value) {
            _directoriesModel.name = value.trim();
          },
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        CustomTextFormField(
            textInputType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            labelText: "Descrição",
            initialValue: _directoriesModel.description,
            border: Borders.customOutlineInputBorder(),
            enabledBorder: Borders.customOutlineInputBorder(),
            focusedBorder: Borders.customOutlineInputBorder(
              color: AppColors.violetShade200,
            ),
            labelStyle: GoogleTextStyles.customTextStyle(),
            hintTextStyle: GoogleTextStyles.customTextStyle(),
            textStyle: GoogleTextStyles.customTextStyle(),
            onChanged: (value) {
              _directoriesModel.description = value.trim();
            },
            validator: (value) {
              return value.isEmpty ? 'Campo obrigatório' : null;
            }),
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
                        await saveContact();
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

  Future<void> saveContact() async {
    //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
    DocumentReference refDB = FirebaseFirestore.instance
        .collection('diretorias')
        .doc(_directoriesModel.id);

    await refDB
        .set({
          'nome': _directoriesModel.name,
          'descricao': _directoriesModel.description,
        })
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                bool isUpdating = _directoriesModel.id == null ? true : false;
                _directoriesModel.id = refDB.id;
                return AlertDialog(
                  title: isUpdating
                      ? Text('Diretoria adicionada com sucesso.')
                      : Text('Diretoria atualizada com sucesso.'),
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
                  title: _directoriesModel.id == null
                      ? Text('Falha ao adicionar Diretoria.')
                      : Text('Falha ao atualizar Diretoria.'),
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
