import 'package:account_manager/views/components/EmailInputField.dart';
import 'package:account_manager/views/components/PasswordInputFiled.dart';
import 'package:account_manager/views/components/SigninButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  GlobalKey<FormState> _key = GlobalKey();

  String username, password;

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
      Navigator.of(context).popAndPushNamed("/home",arguments: username);
    }
  }

  _saveUserName(user){
    this.username = user;
  }

  _savePassword(pass){
    this.password = pass;
  }
}
