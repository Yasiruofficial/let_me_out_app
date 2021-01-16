import 'package:flutter/material.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:let_me_out/enums/AuthOption.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/screens/components/CustomTextField.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/components//logo.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService baseAuthService;

  SignUpPage({this.baseAuthService, this.firestoreService});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Widget registerWidget = Text('Register',
      style:
          TextStyle(fontSize: 20, fontFamily: 'Poppins', color: Colors.white));

  String _email;
  void setEmail(String email) => this._email = email;

  String _password;
  void setPassword(String password) => this._password = password;

  String _confirmPassword;
  void setConfirmPassword(String confirmPassword) =>
      this._confirmPassword = confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Logo(),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(setEmail, "Username", Icon(Icons.email)),
                CustomTextField(setPassword, "Password", Icon(Icons.short_text),
                    isPassword: true),
                CustomTextField(setConfirmPassword, "Confirm Password",
                    Icon(Icons.short_text),
                    isPassword: true),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                SizedBox(height: 10),
                _loginAccountLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Provider.of<LandingPageViewModel>(context, listen: false)
            .updatedAuthOption(AuthOption.sign_in);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        try {
          if (_formKey.currentState.validate()) {
            setState(() {
              registerWidget = LoadingWidget();
              _formKey.currentState.save();
            });

            AppUser _user = await _signUp(_email, _password);
            Provider.of<LandingPageViewModel>(context, listen: false)
                .updatedUser(_user);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.indigo, Colors.cyan])),
        child: registerWidget,
      ),
    );
  }

  Future<AppUser> _signUp(String email, String password) async {
    try {
      return await widget.baseAuthService
          .createUserWithEmailAndPassword(email, password);
    } catch (e) {
      Toast.show(e.toString().split("Exception: ")[1], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
  }
}
