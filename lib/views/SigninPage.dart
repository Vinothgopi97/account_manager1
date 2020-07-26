import 'package:account_manager/views/components/EmailInputField.dart';
import 'package:account_manager/views/components/PasswordInputField.dart';
import 'package:account_manager/views/components/SigninButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  GlobalKey<FormState> _key = GlobalKey();

  String username, password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if(user != null){
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
  }

  showError(String error){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  void signin() async{
    if(_key.currentState.validate()){
      _key.currentState.save();
      try{
        AuthResult result = await _auth.signInWithEmailAndPassword(email: username, password: password);
        user = result.user;
      }
      catch(e){
        showError(e.message);
      }
    }

  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            color: Theme.of(context).backgroundColor,
            child: Card(
              margin: Theme.of(context).cardTheme.margin,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          Text("Sign In", style: Theme.of(context).textTheme.headline1),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          EmailInputField(_saveUserName),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          PasswordInputField(_savePassword),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          SigninButton(_key,_sendToNextScreen)
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _sendToNextScreen(){
    if(_key.currentState.validate())
    {
      _key.currentState.save();
      print(username);
      signin();
    }
  }

  _saveUserName(user){
    this.username = user;
  }

  _savePassword(pass){
    this.password = pass;
  }
}
