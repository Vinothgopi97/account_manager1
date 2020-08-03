import 'package:account_manager/views/DeliveryPersonHomePage.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/SigninButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  DatabaseReference _configDatabaseRef = FirebaseDatabase.instance.reference().child("/config");
  
  FirebaseUser user;

  checkAuthentication() async {
    print("In check auth");
    _auth.onAuthStateChanged.listen((user) async {
      print("User mobile "+user.phoneNumber);
      print("Admin mobile"+adminMobile.toString());
      if(user != null && user.phoneNumber == adminMobile){
        Navigator.of(context).pushReplacementNamed("/adminhome");
      }
      else if(user != null){
        print("DELIVERY PERSON");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => DeliveryPersonHome(deliveryMobiles.indexOf(user.phoneNumber).toString())
          ),
        );
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
         if("+91"+mobile == adminMobile || deliveryMobiles.contains("+91"+mobile)){
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
                               keyboardType: TextInputType.number,
                             ),
                             FlatButton(onPressed: () async {
                               final code = _codeController.text.trim();
                               AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationid, smsCode: code);
                               Navigator.of(context).pop();
                               AuthResult res = await _auth.signInWithCredential(credential).catchError((e)=>{
                                 showError(e.message)
                               });
                             }, child: Text("Signin"))
                           ],
                         ),
                       );
                     }
                 );
               },
               codeAutoRetrievalTimeout: null);
         }
         else{
           showError("Mobile Number not registered as Admin or a Delivery person");
         }
      }
      catch(e){
        showError(e.message);
      }
    }
  }

  FocusNode mobileFocus;
  String adminMobile;
  List<String> deliveryMobiles;

  @override
  void initState() {
    mobileFocus = FocusNode();
    _configDatabaseRef.child("users").orderByKey().equalTo("admin").onValue.listen((event) {
      adminMobile = event.snapshot.value["admin"].toString();
      print("ADMIN"+adminMobile);
    });
    _configDatabaseRef.child("users").child("deliveryperson").onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      print("Delivery Person Mobiles");
      List<dynamic> list =  snapshot.value;
      deliveryMobiles = list.cast();
    });
    this.checkAuthentication();
    super.initState();
  }

  @override
  void dispose() {
    mobileFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        alignment: Alignment.center,
        child: Center(
          child: Container(
            height: 500,
            padding: EdgeInsets.symmetric(vertical: 50),

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
                          MobileNumberInputField(_savePhoneNumber, mobileFocus, null),
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
  _savePhoneNumber(num){
    this.mobile = num;
  }
}
