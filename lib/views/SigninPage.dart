import 'package:account_manager/views/DeliveryPersonHomePage.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/SigninButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  GlobalKey<FormState> _key = GlobalKey();

  String username, password, mobile;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  showError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  final _codeController = TextEditingController();
  void signin() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      try {
        print(
            "Delivery mobiles has ${deliveryMobiles.contains("+91" + mobile)}");
        // print(deliveryMobiles);
        // print(mobile);
        // print(adminMobile);
        if ("+91" + mobile == adminMobile ||
            deliveryMobiles.contains("+91" + mobile)) {
          await _auth.verifyPhoneNumber(
              phoneNumber: "+91" + mobile,
              timeout: Duration(seconds: 60),
              verificationCompleted: (credential) async {
                Navigator.of(context).pop();
                await _auth.signInWithCredential(credential);
              },
              verificationFailed: (e) {
                showError(e.toString());
              },
              codeSent: (String verificationid, [int forceresendingid]) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Align(
                          alignment: Alignment.center,
                          child: Text("Enter the code sent"),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                            ),
                            FlatButton(
                                onPressed: () async {
                                  final code = _codeController.text.trim();
                                  AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationid,
                                          smsCode: code);
                                  Navigator.of(context).pop();
                                  await _auth
                                      .signInWithCredential(credential)
                                      .catchError(
                                          (e) => showError(e.toString()));
                                },
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  "Signin",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      );
                    });
              },
              codeAutoRetrievalTimeout: (verificationId) =>
                  {print(verificationId)});
        } else {
          showError(
              "Mobile Number not registered as Admin or a Delivery person");
        }
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  FocusNode mobileFocus;
  String adminMobile;
  List<String> deliveryMobiles = new List<String>();

  @override
  void initState() {
    mobileFocus = FocusNode();
    getDeliveryPersonMobiles();
    this.checkAuthentication();
    super.initState();
  }

  checkAuthentication() async {
    print("In check auth");

    _auth.authStateChanges().listen((user) async {
      await getDeliveryPersonMobiles();
      if (user != null && user.phoneNumber == adminMobile) {
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushReplacementNamed("/adminhome");
      } else if (user != null && deliveryMobiles.contains(user.phoneNumber)) {
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => DeliveryPersonHome(
                  deliveryMobiles.indexOf(user.phoneNumber).toString())),
        );
      }
    });
  }

  getDeliveryPersonMobiles() async {
    List<dynamic> list;
    await FirebaseFirestore.instance
        .collection("config")
        .doc("users")
        .get()
        .then((value) => {
              adminMobile = value.get("admin"),
              list = value.get("deliveryperson"),
              deliveryMobiles = list.cast(),
            });
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
                          Align(
                            alignment: Alignment.center,
                            child: Text("Freez Milk",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 0.4)),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Container(
                            child: MobileNumberInputField(
                                _savePhoneNumber, mobileFocus, null),
                            padding: EdgeInsets.only(right: 50),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          SigninButton(_sendToNextScreen)
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

  _sendToNextScreen() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      signin();
    }
  }

  _savePhoneNumber(num) {
    this.mobile = num;
  }
}
