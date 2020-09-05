import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    deliveryPersons = {};
    deliverypersonNames = List();
    getDeliveryPersons();
    nameFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
  }

  getDeliveryPersons() async {
    List<String> names = List();
    deliveryPersons.clear();
    deliverypersonNames.clear();
    FirebaseFirestore.instance
        .collection("deliverypersons")
        .snapshots()
        .forEach((element) {
      element.docs.forEach((el) {
        String name = el.get("name");
        String id = el.id;
        deliveryPersons.putIfAbsent(name, () => id);
        names.add(name);
      });
      setState(() {
        deliverypersonNames = names;
        selected = deliverypersonNames.length >= 1
            ? deliverypersonNames.elementAt(0)
            : "No Delivery Persons available";
      });
    });
  }

  saveCustomer() async {
    if (_name.isNotEmpty && _mobileNumber.isNotEmpty) {
      _registeredOn = DateTime.now().toString();
      user = FirebaseAuth.instance.currentUser;

      int id = 0;
      String deliveryPersonId = deliveryPersons[selected].toString();
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
