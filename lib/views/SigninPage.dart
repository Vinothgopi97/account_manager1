import 'package:account_manager/views/components/MobileNumberInputField.dart';
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

  String username, password,mobile;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  checkAuthentication() async {
    print("In check auth");
    _auth.onAuthStateChanged.listen((user) async {
      if(user != null){
//        if(user.uid == "sQAL8xDRgQWjRcVEqyxXQ4Yo44g2"){
          //admin
          print("admin");
          Navigator.of(context).pushReplacementNamed("/adminhome");
//        }
//        else{
//          print("delivery person");
//          Navigator.of(context).pushReplacementNamed("/deliveryhome");
//        }

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

  final _codeController = TextEditingController();
  void signin() async{
    if(_key.currentState.validate()){
      _key.currentState.save();
      try{
//        AuthResult result = await _auth.signInWithEmailAndPassword(email: username, password: password);
      print(mobile);
         await _auth.verifyPhoneNumber(
            phoneNumber: "+91"+mobile,
            timeout: Duration(seconds: 60),
            verificationCompleted: (AuthCredential credential) async {
              Navigator.of(context).pop();
              AuthResult res = await _auth.signInWithCredential(credential);
            },
            verificationFailed: (AuthException e){
              showError(e.message);
            },
            codeSent: (String verificationid,[int forceresendingid]){
              showDialog(context: context,
              barrierDismissible: false,

                builder: (context){
                return AlertDialog(
                  title: Text("Enter the code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                      FlatButton(onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationid, smsCode: code);
                        AuthResult res = await _auth.signInWithCredential(credential);
                      }, child: Text("Signin"))
                    ],
                  ),
                );
                }
              );
            },
            codeAutoRetrievalTimeout: null);
      }
      catch(e){
        showError(e.message);
      }
    }
//    AuthResult res = await _auth.signInAnonymously();
  }

  FocusNode emailFocus;
  FocusNode passwordFocus;
  FocusNode mobileFocus;

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    mobileFocus = FocusNode();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    mobileFocus.dispose();
    super.dispose();
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
//                          EmailInputField(_saveUserName,emailFocus,passwordFocus),
                          MobileNumberInputField(_savePhoneNumber, mobileFocus, null),
//                          Padding(padding: EdgeInsets.only(top: 10)),
//                          PasswordInputField(_savePassword,passwordFocus,emailFocus),
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

  _savePhoneNumber(num){
    this.mobile = num;
  }

  _savePassword(pass){
    this.password = pass;
  }
}
