import 'package:account_manager/views/components/EmailInputField.dart';
import 'package:account_manager/views/components/PasswordInputFiled.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateDeliveryPersonAccountPage extends StatefulWidget {
  @override
  _CreateDeliveryPersonAccountPageState createState() => _CreateDeliveryPersonAccountPageState();
}

class _CreateDeliveryPersonAccountPageState extends State<CreateDeliveryPersonAccountPage> {
  GlobalKey<FormState> _key = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username, password;

  FirebaseUser user;

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

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if(user != null){
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
  }

  @override
  void initState() {
    super.initState();
//    this.checkAuthentication();
  }

  signUp() async{
   AuthResult res = await _auth.createUserWithEmailAndPassword(email: username, password: password);

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
                          Text("Sign Up", style: Theme.of(context).textTheme.headline1),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          EmailInputField(_saveUserName),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          PasswordInputField(_savePassword),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          SignupButton(_key,_sendToNextScreen)
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
      signUp();
    }
  }

  _saveUserName(user){
    this.username = user;
  }

  _savePassword(pass){
    this.password = pass;
  }
}
