import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/models/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CategoriesAdmin extends StatelessWidget {
  final CategoriesModel categories;

  const CategoriesAdmin({Key key, this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Categorias'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: CategoriesAdminBody(categories),
    );
  }
}

class CategoriesAdminBody extends StatefulWidget {
  CategoriesAdminBody(this.categories);
  final CategoriesModel categories;

  @override
  _CategoriesAdminBodyState createState() =>
      _CategoriesAdminBodyState(this.categories);
}

class _CategoriesAdminBodyState extends State<CategoriesAdminBody> {
  _CategoriesAdminBodyState(this.categorie);
  final CategoriesModel categorie;

  final _form = GlobalKey<FormState>();
  CategoriesModel _categoriesModel;
  bool _progressBarActive = false;

  initState() {
    super.initState();

    _categoriesModel = CategoriesModel.fromCategories(categorie);
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
          textCapitalization: TextCapitalization.sentences,
          labelText: "Título",
          initialValue: _categoriesModel.name,
          border: Borders.customOutlineInputBorder(),
          enabledBorder: Borders.customOutlineInputBorder(),
          focusedBorder: Borders.customOutlineInputBorder(
            color: const Color(0xFF655796),
          ),
          labelStyle: GoogleTextStyles.customTextStyle(),
          hintTextStyle: GoogleTextStyles.customTextStyle(),
          textStyle: GoogleTextStyles.customTextStyle(),
          onChanged: (value) {
            _categoriesModel.name = value.trim();
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
            initialValue: _categoriesModel.description,
            border: Borders.customOutlineInputBorder(),
            enabledBorder: Borders.customOutlineInputBorder(),
            focusedBorder: Borders.customOutlineInputBorder(
              color: AppColors.violetShade200,
            ),
            labelStyle: GoogleTextStyles.customTextStyle(),
            hintTextStyle: GoogleTextStyles.customTextStyle(),
            textStyle: GoogleTextStyles.customTextStyle(),
            onChanged: (value) {
              _categoriesModel.description = value.trim();
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
        .collection('categorias')
        .doc(_categoriesModel.id);

    await refDB
        .set({
          'nome': _categoriesModel.name,
          'descricao': _categoriesModel.description,
        })
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                bool isUpdating = _categoriesModel.id == null ? true : false;
                _categoriesModel.id = refDB.id;
                return AlertDialog(
                  title: isUpdating
                      ? Text('Categoria adicionada com sucesso.')
                      : Text('Categoria atualizada com sucesso.'),
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
                  title: _categoriesModel.id == null
                      ? Text('Falha ao adicionar Categoria.')
                      : Text('Falha ao atualizar Categoria.'),
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
