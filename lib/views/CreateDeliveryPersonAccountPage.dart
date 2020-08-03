import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
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

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("deliveryperson");
  DatabaseReference _idDataReference  = FirebaseDatabase.instance.reference().child("config");

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


  @override
  void initState() {

    _auth = FirebaseAuth.instance;
    emailNode = FocusNode();
    passwordNode = FocusNode();
    mobileNode = FocusNode();
    nameNode = FocusNode();
    addressNode = FocusNode();
    super.initState();
  }

  saveDeliveryPerson() async{
    if( _name.isNotEmpty  && _mobileNumber.isNotEmpty ){
      _registeredOn = DateTime.now().toString();
      user = await FirebaseAuth.instance.currentUser();

      DataSnapshot snapshot = await _idDataReference.once();
      int id = int.parse(snapshot.value["latestdeliverypersonid"].toString());

      DeliveryPerson deliveryPerson = DeliveryPerson(id.toString(),_name,_mobileNumber,_registeredOn);
//      Map<String, dynamic> m = {id.toString():deliveryPerson.toJson()};
      String old = id.toString();
      id = id+1;
      Map<String,dynamic> idmap = {"latestdeliverypersonid":id};

      await _databaseReference.child(old).set(deliveryPerson.toJson()).whenComplete(() async => {
        await _idDataReference.update(idmap),
        await FirebaseDatabase.instance.reference().child("config").child("deliverypersons").child(old).set(deliveryPerson.name),
        await FirebaseDatabase.instance.reference().child("config").child("users").child("deliveryperson").child(old).set("+91"+deliveryPerson.mobileNumber),
        showSuccess("Delivery person account created"),
        _key.currentState.reset()
      }).catchError((err)=>{
        showError(err.message)
      });
//      await _databaseReference.push().set(deliveryPerson.toJson()).whenComplete(() async => {
//        await _idDataReference.update(idmap),
//            showSuccess("Delivery person account created"),
//          _key.currentState.reset()
//    }).catchError((err)=>{
//    showError(err.message)
//    });
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
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Create Delivery Person", style: TextStyle(color: Colors.white),),
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
                          height: 400,
                          child:  ListView(
                            padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                            children: <Widget>[
                              NameInputField(_saveName,nameNode,mobileNode),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              MobileNumberInputField(_saveMobile,mobileNode,null),
                              Padding(padding: EdgeInsets.only(top: 10)),
//                              DateInputField(_saveDateOfBirth,"Date Of Birth",null,null),
//                              Padding(padding: EdgeInsets.only(top: 10)),
//                              AddressInputFiled(_saveAddress,addressNode,emailNode),
//                              Padding(padding: EdgeInsets.only(top: 10)),
//                              EmailInputField(_saveUserName,emailNode,passwordNode),
//                              Padding(padding: EdgeInsets.only(top: 10)),
//                              PasswordInputField(_savePassword,passwordNode,null),
//                              Padding(padding: EdgeInsets.only(top: 10)),
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
      saveDeliveryPerson();
    }
  }


  _saveName(name){
    this._name = name;
  }

  _saveMobile(mobile){
    this._mobileNumber = mobile;
  }

}
