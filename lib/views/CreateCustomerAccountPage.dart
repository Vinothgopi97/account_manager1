import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:account_manager/views/components/NameInputField.dart';
import 'package:account_manager/views/components/SignupButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CreateCustomerAccountPage extends StatefulWidget {
  @override
  _CreateCustomerAccountPageState createState() => _CreateCustomerAccountPageState();
}

class _CreateCustomerAccountPageState extends State<CreateCustomerAccountPage> {
  GlobalKey<FormState> _key = GlobalKey();

  FirebaseAuth _auth;

  String username, password;

  FirebaseUser user;

  DatabaseReference _databaseReference;

  DatabaseReference _idDataReference;

  String _name = "";
  String _registeredOn = "";
  String _mobileNumber = "";
  String _address = "";

  FocusNode nameFocusNode;
  FocusNode mobileFocusNode;
  FocusNode addressFocusNode;

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
    _databaseReference = FirebaseDatabase.instance.reference().child("customer");
    _idDataReference = FirebaseDatabase.instance.reference().child("customerid");
    nameFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
    addressFocusNode = FocusNode();
//    this.checkAuthentication();
  }

  saveCustomer() async{
    if( _name.isNotEmpty && _mobileNumber.isNotEmpty){
      _registeredOn = DateTime.now().toString();

      user = await FirebaseAuth.instance.currentUser();
      DataSnapshot snapshot = await _idDataReference.once();
      int id = int.parse(snapshot.value["latestcustomerid"].toString());
      Customer customer = Customer( id.toString(), _name, _mobileNumber,DateTime.now().toString());
      id = id+1;
      Map<String,dynamic> idmap = {"latestcustomerid":id};
      await _databaseReference.push().set(customer.toJson()).whenComplete(()async => {
          await _idDataReference.update(idmap),
            showSuccess("Customer Added"),
          _key.currentState.reset()
    }).catchError((err)=>{
    showError(err.message)
    });
  }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    mobileFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
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
                            padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                            children: <Widget>[
                              NameInputField(_saveName, nameFocusNode,mobileFocusNode),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              MobileNumberInputField(_saveMobile,mobileFocusNode,addressFocusNode),
//                              Padding(padding: EdgeInsets.only(top: 10)),
//                              AddressInputFiled(_saveAddress,addressFocusNode,null),
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
      saveCustomer();
    }
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

}
