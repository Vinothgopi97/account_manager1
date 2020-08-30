import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modal/DeliveryPerson.dart';

class CreateDeliveryPersonAccountPage extends StatefulWidget {
  @override
  _CreateDeliveryPersonAccountPageState createState() =>
      _CreateDeliveryPersonAccountPageState();
}

class _CreateDeliveryPersonAccountPageState
    extends State<CreateDeliveryPersonAccountPage> {
  GlobalKey<FormState> _key = GlobalKey();

  User user;

  // DatabaseReference _databaseReference =
  //     FirebaseDatabase.instance.reference().child("deliveryperson");
  // DatabaseReference _idDataReference =
  //     FirebaseDatabase.instance.reference().child("config");

  String _name = "";
  String _registeredOn = "";
  String _mobileNumber = "";
  FocusNode nameNode;
  FocusNode mobileNode;

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

  showSuccess(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Success"),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  void initState() {
    mobileNode = FocusNode();
    nameNode = FocusNode();
    super.initState();
  }

  saveDeliveryPerson() async {
    if (_name.isNotEmpty && _mobileNumber.isNotEmpty) {
      _registeredOn = DateTime.now().toString();
//      user = FirebaseAuth.instance.currentUser;

//      DataSnapshot snapshot = await _idDataReference.once();
      int id = 0;
      await FirebaseFirestore.instance
          .collection("config")
          .doc("deliveryperson")
          .get()
          .then((value) => {id = value.get("nextId")});

      DeliveryPerson deliveryPerson =
          DeliveryPerson(id.toString(), _name, _mobileNumber, _registeredOn);
      List<dynamic> arr;
      await FirebaseFirestore.instance
          .collection("deliverypersons")
          .doc(id.toString())
          .set(deliveryPerson.toJson())
          .whenComplete(() async => {
                showSuccess("Delivery person account created"),
                _key.currentState.reset(),
                FirebaseFirestore.instance
                    .collection("config")
                    .doc("deliveryperson")
                    .set({"nextId": id + 1}),
                await FirebaseFirestore.instance
                    .collection("config")
                    .doc("users")
                    .get()
                    .then((value) => {
                          arr = value.get("deliveryperson"),
                          if (arr == null) arr = new List<String>(),
                          arr.add("+91" + deliveryPerson.mobileNumber),
//                          print(arr),
                        })
              })
          .catchError((err) => {showError(err.message)});
      FirebaseFirestore.instance
          .collection("config")
          .doc("users")
          .update({"deliveryperson": arr});

//      Map<String, dynamic> m = {id.toString():deliveryPerson.toJson()};
//      String old = id.toString();
//      id = id + 1;
//      Map<String, dynamic> idmap = {"latestdeliverypersonid": id};
//
//      await _databaseReference
//          .child(old)
//          .set(deliveryPerson.toJson())
//          .whenComplete(() async => {
//                await _idDataReference.update(idmap),
//                await FirebaseDatabase.instance
//                    .reference()
//                    .child("config")
//                    .child("deliverypersons")
//                    .child(old)
//                    .set(deliveryPerson.name),
//                await FirebaseDatabase.instance
//                    .reference()
//                    .child("config")
//                    .child("users")
//                    .child("deliveryperson")
//                    .child(old)
//                    .set("+91" + deliveryPerson.mobileNumber),
//                showSuccess("Delivery person account created"),
//                _key.currentState.reset()
//              })
//          .catchError((err) => {showError(err.message)});
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
    nameNode.dispose();
    mobileNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "Create Delivery Person",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Container(
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
                          child: Container(
                            height: 400,
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 10),
                              children: <Widget>[
                                NameInputField(_saveName, nameNode, mobileNode),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                MobileNumberInputField(
                                    _saveMobile, mobileNode, null),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                SignupButton(_sendToNextScreen)
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )),
            ),
          ),
        ));
  }

  _sendToNextScreen() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      saveDeliveryPerson();
    }
  }

  _saveName(name) {
    this._name = name;
  }

  _saveMobile(mobile) {
    this._mobileNumber = mobile;
  }
}
