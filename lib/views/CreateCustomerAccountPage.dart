import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateCustomerAccountPage extends StatefulWidget {
  @override
  _CreateCustomerAccountPageState createState() =>
      _CreateCustomerAccountPageState();
}

class _CreateCustomerAccountPageState extends State<CreateCustomerAccountPage> {
  GlobalKey<FormState> _key = GlobalKey();

  User user;

  // DatabaseReference _databaseReference;
  // DatabaseReference _idDataReference;

  String _name = "";
  String _mobileNumber = "";
  String _registeredOn = "";
  FocusNode nameFocusNode;
  FocusNode mobileFocusNode;

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

  Map<String, String> deliveryPersons = {};
  List<String> deliverypersonNames;
  String selected = "";
  @override
  void initState() {
    super.initState();
    // _databaseReference =
    //     FirebaseDatabase.instance.reference().child("customer");
    // _idDataReference = FirebaseDatabase.instance.reference().child("config");
    deliveryPersons = {};
    deliverypersonNames = List();
    getDeliveryPersons();
    nameFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
  }

  getDeliveryPersons() async {
    FirebaseDatabase.instance
        .reference()
        .child("config")
        .child("deliverypersons")
        .onValue
        .listen((event) {
      DataSnapshot snapshot = event.snapshot;
//      LinkedHashMap<dynamic,dynamic> m = snapshot.value;
      print(snapshot.value);
      List<dynamic> m = snapshot.value;
      setState(() {
        deliverypersonNames = m.cast();
        selected = deliverypersonNames.length >= 1
            ? deliverypersonNames.elementAt(0)
            : "No Delivery Persons available";
      });
      for (int j = 0; j < deliverypersonNames.length; j++) {
        deliveryPersons.putIfAbsent(
            deliverypersonNames.elementAt(j), () => j.toString());
      }
    });
  }

  saveCustomer() async {
    if (_name.isNotEmpty && _mobileNumber.isNotEmpty) {
      _registeredOn = DateTime.now().toString();
      user = FirebaseAuth.instance.currentUser;

      int id = 0;
      // DataSnapshot snapshot = await _idDataReference.once();
      // int id = int.parse(snapshot.value["latestcustomerid"].toString());
      String deliveryPersonId = deliveryPersons[selected].toString();
      // String old = id.toString();

      // id = id + 1;
      // Map<String, dynamic> idmap = {"latestcustomerid": id};

      await FirebaseFirestore.instance
          .collection("config")
          .doc("customer")
          .get()
          .then((value) => {id = value.get("nextid")});
      Customer customer = Customer(id.toString(), _name, _mobileNumber,
          deliveryPersonId, selected, Timestamp.now());
      FirebaseFirestore.instance
          .collection("customers")
          .doc(id.toString())
          .set(customer.toJson())
          .whenComplete(() => {
                FirebaseFirestore.instance
                    .collection("config")
                    .doc("customer")
                    .set({"nextid": id + 1}),
                showSuccess("Customer Added"),
                _key.currentState.reset()
              })
          .catchError((err) => {showError(err.message)});
//      await _databaseReference
//          .child(old)
//          .set(customer.toJson())
//          .whenComplete(() async => {
//                await _idDataReference.update(idmap),
//                showSuccess("Customer Added"),
//                _key.currentState.reset()
//              })
//          .catchError((err) => {showError(err.message)});
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    mobileFocusNode.dispose();
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
            "Add Customer",
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
                                NameInputField(
                                    _saveName, nameFocusNode, mobileFocusNode),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                MobileNumberInputField(
                                    _saveMobile, mobileFocusNode, null),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Delivery Person"),
                                    DropdownButton<String>(
                                      items: deliverypersonNames
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem<String>(
                                            value: e.toString(),
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(e.toString()),
                                              ],
                                            ));
                                      }).toList(),
                                      onChanged: (e) {
                                        setState(() {
                                          selected = e.toString();
                                        });
                                      },
                                      value: selected,
                                    ),
                                  ],
                                ),
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
      saveCustomer();
    }
  }

  _saveName(name) {
    this._name = name;
  }

  _saveMobile(mobile) {
    this._mobileNumber = mobile;
  }
}
