import 'package:account_manager/views/components/AddressInputField.dart';
import 'package:account_manager/views/components/DateInputField.dart';
import 'package:account_manager/views/components/EmailInputField.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
import 'package:account_manager/views/components/PasswordInputField.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modal/DeliveryPerson.dart';


class CreateDeliveryPersonAccountPage extends StatefulWidget {
  @override
  _CreateDeliveryPersonAccountPageState createState() => _CreateDeliveryPersonAccountPageState();
}

class _CreateDeliveryPersonAccountPageState extends State<CreateDeliveryPersonAccountPage> {
  GlobalKey<FormState> _key = GlobalKey();

  FirebaseAuth _auth;

  String username, password;

  FirebaseUser user;

  DatabaseReference _databaseReference;

  String _name = "";
  String _email = "";
  String _dateOfBirth = "";
  String _registeredOn = "";
  String _mobileNumber = "";
  String _address = "";

  FocusNode nameNode;
  FocusNode emailNode;
  FocusNode mobileNode;
  FocusNode passwordNode;
  FocusNode addressNode;

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

  showSuccess(String text){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Success"),
        content: Text(text),
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
    _auth = FirebaseAuth.instance;
    _databaseReference = FirebaseDatabase.instance.reference().child("deliveryperson");
    emailNode = FocusNode();
    passwordNode = FocusNode();
    mobileNode = FocusNode();
    nameNode = FocusNode();
    addressNode = FocusNode();
//    this.checkAuthentication();
  }


  signUp() async{
   AuthResult res = await _auth.createUserWithEmailAndPassword(email: username, password: password);
  }

  saveDeliveryPerson() async{
    if( _name.isNotEmpty && _email.isNotEmpty && _dateOfBirth.isNotEmpty && _mobileNumber.isNotEmpty && _address.isNotEmpty){
      _registeredOn = DateTime.now().toString();
      user = await FirebaseAuth.instance.currentUser();
      DeliveryPerson deliveryPerson = DeliveryPerson(_name,_email,_dateOfBirth,_mobileNumber,_registeredOn,_address,user.email);
      await _databaseReference.push().set(deliveryPerson.toJson()).whenComplete(() => {
            showSuccess("Delivery person account created"),
          _key.currentState.reset()
    }).catchError((err)=>{
    showError(err.message)
    });
  }
  }

  @override
  void dispose() {
    emailNode.dispose();
    passwordNode.dispose();
    nameNode.dispose();
    mobileNode.dispose();
    addressNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Delivery Person"),
      ),
      body: SafeArea(child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                        key: _key,
                        child:Container(
                          height: MediaQuery.of(context).size.height,
                          child:  ListView(
                            children: <Widget>[
                              NameInputField(_saveName,nameNode,mobileNode),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              MobileNumberInputField(_saveMobile,mobileNode,null),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              DateInputField(_saveDateOfBirth,"Date Of Birth",null,null),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              AddressInputFiled(_saveAddress,addressNode,emailNode),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              EmailInputField(_saveUserName,emailNode,passwordNode),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              PasswordInputField(_savePassword,passwordNode,null),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              SignupButton(_key,_sendToNextScreen)
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),)
    );
  }

  _sendToNextScreen(){
    if(_key.currentState.validate())
    {
      _key.currentState.save();
      signUp();
      saveDeliveryPerson();
    }
  }

  _saveUserName(user){
    this.username = user;
    this._email = user;
  }

  _saveName(name){
    this._name = name;
  }

  _saveAddress(address){
    this._address = address;
  }

  _saveMobile(mobile){
    this._mobileNumber = mobile;
  }

  _saveDateOfBirth(dob){
    this._dateOfBirth = dob;
  }

  _savePassword(pass){
    this.password = pass;
  }
}
