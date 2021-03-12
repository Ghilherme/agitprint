import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/clipShadowPath.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/home/home_screen.dart';
import 'package:agitprint/login/custom_clip.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSwitched = false;

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
    return Column(
      children: <Widget>[
        CustomTextFormField(
          textInputType: TextInputType.text,
          labelText: "Email",
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
          height: 20.0,
        ),
        CustomTextFormField(
          textInputType: TextInputType.text,
          labelText: "Senha",
          obscured: true,
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
          child: CustomButton(
            title: "Login",
            elevation: 8,
            textStyle: theme.textTheme.subtitle2.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
            color: AppColors.blue,
            height: 40,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        )
      ],
    );
  }
}
