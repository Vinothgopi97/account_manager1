import 'package:firebase_database/firebase_database.dart';

class Customer{

  String _id;
  String _name;
  DateTime _customerRegisterdOn;
  String _mobileNumber;
  String _address;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Customer(this._name, this._customerRegisterdOn, this._mobileNumber,
      this._address);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get customerRegisterdOn => _customerRegisterdOn;

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get mobileNumber => _mobileNumber;

  set mobileNumber(String value) {
    _mobileNumber = value;
  }

  set customerRegisterdOn(DateTime value) {
    _customerRegisterdOn = value;
  }

  Customer.withId(this._id,this._name, this._customerRegisterdOn, this._mobileNumber, this._address);

  Customer.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._customerRegisterdOn = snapshot.value['registeredOn'];
    this._mobileNumber = snapshot.value['mobile'];
    this._address = snapshot.value['address'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : _name,
      "registeredOn" : _customerRegisterdOn,
      "mobile" : _mobileNumber,
      "address" : _address,
      "userType" : "customer"
    };
  }
}