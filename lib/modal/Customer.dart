import 'package:firebase_database/firebase_database.dart';

class Customer{

  String _id;
  String _customerId;
  String _name;
  String _mobileNumber;
  String _address;
  String _customerRegisterdOn;
  String _customerRegisteredBy;


  String get customerId => _customerId;

  set customerId(String value) {
    _customerId = value;
  }

  String get customerRegisteredBy => _customerRegisteredBy;

  set customerRegisteredBy(String value) {
    _customerRegisteredBy = value;
  }

  String get customerRegisterdOn => _customerRegisterdOn;

  set customerRegisterdOn(String value) {
    _customerRegisterdOn = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Customer(this._customerId, this._name, this._mobileNumber, this._address,
      this._customerRegisterdOn, this._customerRegisteredBy);

  String get name => _name;

  set name(String value) {
    _name = value;
  }


  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get mobileNumber => _mobileNumber;

  set mobileNumber(String value) {
    _mobileNumber = value;
  }


  Customer.withId(this._id,this._name, this._customerRegisterdOn, this._mobileNumber, this._address);

  Customer.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._customerRegisterdOn = snapshot.value['registeredOn'];
    this._mobileNumber = snapshot.value['mobile'];
    this._address = snapshot.value['address'];
    this._customerRegisteredBy = snapshot.value['registeredBy'];
    this._customerId = snapshot.value['customerId'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : _name,
      "registeredOn" : _customerRegisterdOn,
      "mobile" : _mobileNumber,
      "address" : _address,
      "userType" : "customer",
      "registeredBy": _customerRegisteredBy,
      "customerId": _customerId
    };
  }
}