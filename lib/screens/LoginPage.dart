import 'package:flutter/material.dart';
import 'package:let_me_out/enums/AuthOption.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/screens/components/CustomDivider.dart';
import 'package:let_me_out/screens/components/CustomTextField.dart';
import 'package:let_me_out/screens/components/FBLoginButton.dart';
import 'package:let_me_out/screens/components/loading_widget.dart';
import 'package:let_me_out/screens/components/logo.dart';
import 'package:let_me_out/services/FirebaseAuthService.dart';
import 'package:let_me_out/view_models/LandingPage_view_model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({@required this.baseAuthService});

  final FirebaseAuthService baseAuthService;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Widget loginWidget =
      Text('Login', style: TextStyle(fontSize: 20, color: Colors.white));

  String _email;
  void setEmail(String email) {
    this._email = email;
  }

  String _password;
  void setPassword(String password) {
    this._password = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Logo(),
              SizedBox(height: 30),
              CustomTextField(
                setEmail,
                "Email id",
                Icon(Icons.email),
              ),
              CustomTextField(
                setPassword,
                "Password",
                Icon(Icons.short_text),
                isPassword: true,
              ),
              SizedBox(height: 20),
              _submitButton(context),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerRight,
                child: Text('Forgot Password ?',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              CustomDivider(text: "or"),
              FBLoginButton(),
              SizedBox(height: 10),
              _createAccountLabel(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Provider.of<LandingPageViewModel>(context, listen: false)
            .updatedAuthOption(AuthOption.sign_up);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            loginWidget = LoadingWidget();
            _formKey.currentState.save();
          });

          AppUser _user = await _signIn(_email, _password);

          final landingPageNotifier =
              Provider.of<LandingPageViewModel>(context, listen: false);
          landingPageNotifier.updatedUser(_user);
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
        child: loginWidget,
      ),
    );
  }

  Future<AppUser> _signIn(String email, String password) async {
    try {
      AppUser _user = await widget.baseAuthService
          .signInWithEmailAndPassword(email, password);
      return _user;
    } catch (e) {
      Toast.show(e.toString().split("Exception: ")[1], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
  }
}
