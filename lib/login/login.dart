import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/clipShadowPath.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/home/home_screen.dart';
import 'package:agitprint/login/custom_clip.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _password;
  String _email;
  final _form = GlobalKey<FormState>();
  bool _progressBarActive = false;

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              ClipShadowPath(
                clipper: CustomClip(),
                shadow: Shadow(blurRadius: 24, color: AppColors.blue),
                child: Container(
                  height: heightOfScreen * 0.4,
                  width: widthOfScreen,
                  color: AppColors.blue,
                  child: Container(
                    margin: EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: heightOfScreen * 0.1,
                        ),
                        Text(
                          "Bem-vindo",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 20,
                                color: AppColors.white,
                              ),
                        ),
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: AppColors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                padding: EdgeInsets.all(0),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    return Form(
        key: _form,
        child: Column(
          children: <Widget>[
            CustomTextFormField(
                textInputType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                labelText: "Email",
                border: Borders.customOutlineInputBorder(),
                enabledBorder: Borders.customOutlineInputBorder(),
                focusedBorder: Borders.customOutlineInputBorder(
                  color: const Color(0xFF655796),
                ),
                onChanged: (val) {
                  _email = val.trim();
                },
                labelStyle: GoogleTextStyles.customTextStyle(),
                hintTextStyle: GoogleTextStyles.customTextStyle(),
                textStyle: GoogleTextStyles.customTextStyle(),
                validator: (value) {
                  return value.isEmpty
                      ? 'Campo obrigatório'
                      : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)
                          ? null
                          : 'Email inválido';
                }),
            SizedBox(
              height: 20.0,
            ),
            CustomTextFormField(
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              labelText: "Senha",
              obscured: true,
              hasSuffixIcon: true,
              suffixIcon: Icon(
                Icons.lock,
                color: AppColors.blackShade10,
              ),
              onChanged: (val) {
                _password = val;
              },
              border: Borders.customOutlineInputBorder(),
              enabledBorder: Borders.customOutlineInputBorder(),
              focusedBorder: Borders.customOutlineInputBorder(
                color: AppColors.violetShade200,
              ),
              labelStyle: GoogleTextStyles.customTextStyle(),
              hintTextStyle: GoogleTextStyles.customTextStyle(),
              textStyle: GoogleTextStyles.customTextStyle(),
              validator: (value) => value.isEmpty ? 'Senha obrigatório' : null,
            ),
            SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
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
                      title: "Login",
                      elevation: 8,
                      textStyle: theme.textTheme.subtitle2.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      color: AppColors.blue,
                      height: 40,
                      onPressed: () {
                        signin();
                      },
                    ),
            )
          ],
        ));
  }

  void signin() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });
      UserCredential userCredential;

      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        String error = e.message;
        if (e.code == 'user-not-found') {
          error = 'Usuário não cadastrado.';
        } else if (e.code == 'wrong-password') {
          error = 'Senha incorreta!';
        }
        final snackBar = SnackBar(content: Text(error));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _progressBarActive = false;
        });
      }
      if (userCredential != null)
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
