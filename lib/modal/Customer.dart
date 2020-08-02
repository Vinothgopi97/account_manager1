import 'package:firebase_database/firebase_database.dart';

class Customer{

  String _id;
  String _customerId;
  String _name;
  String _mobileNumber;
  String _customerRegisterdOn;
  String _deliveryPersonId;
  String _deliveryPersonName;


  String get deliveryPersonName => _deliveryPersonName;

  set deliveryPersonName(String value) {
    _deliveryPersonName = value;
  }

  String get deliveryPersonId => _deliveryPersonId;

  set deliveryPersonId(String value) {
    _deliveryPersonId = value;
  }

  Customer(this._customerId, this._name, this._mobileNumber,this._deliveryPersonId,this._deliveryPersonName,
      this._customerRegisterdOn);

  String get customerId => _customerId;

  set customerId(String value) {
    _customerId = value;
  }

  String get customerRegisterdOn => _customerRegisterdOn;

  set customerRegisterdOn(String value) {
    _customerRegisterdOn = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get mobileNumber => _mobileNumber;

  set mobileNumber(String value) {
    _mobileNumber = value;
  }


  Customer.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._customerRegisterdOn = snapshot.value['registeredOn'];
    this._mobileNumber = snapshot.value['mobile'];
    this._customerId = snapshot.value['customerId'];
    this._deliveryPersonId = snapshot.value['deliveryPersonId'];
    this._deliveryPersonName = snapshot.value["deliveryPersonName"];
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : _name,
      "registeredOn" : _customerRegisterdOn,
      "mobile" : _mobileNumber,
      "userType" : "customer",
      "customerId": _customerId,
      "deliveryPersonId": _deliveryPersonId,
      "deliveryPersonName": _deliveryPersonName
    };
  }
}