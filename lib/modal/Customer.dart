import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String _id;
  String _customerId;
  String _name;
  String _mobileNumber;
  Timestamp _customerRegisterdOn;
  String _deliveryPersonId;
  String _deliveryPersonName;
  String _active;

  String get active => _active;

  set active(String value) {
    _active = value;
  }

  String get deliveryPersonName => _deliveryPersonName;

  set deliveryPersonName(String value) {
    _deliveryPersonName = value;
  }

  String get deliveryPersonId => _deliveryPersonId;

  set deliveryPersonId(String value) {
    _deliveryPersonId = value;
  }

  Customer(
      this._customerId,
      this._name,
      this._mobileNumber,
      this._deliveryPersonId,
      this._deliveryPersonName,
      this._customerRegisterdOn) {
    this._active = "Y";
  }

  String get customerId => _customerId;

  set customerId(String value) {
    _customerId = value;
  }

  Timestamp get customerRegisterdOn => _customerRegisterdOn;

  set customerRegisterdOn(Timestamp value) {
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

  // Customer.fromSnapshot(DataSnapshot snapshot) {
  //   this._id = snapshot.key;
  //   this._name = snapshot.value['name'];
  //   this._customerRegisterdOn = snapshot.value['registeredOn'];
  //   this._mobileNumber = snapshot.value['mobile'];
  //   this._customerId = snapshot.value['customerId'];
  //   this._deliveryPersonId = snapshot.value['deliveryPersonId'];
  //   this._deliveryPersonName = snapshot.value["deliveryPersonName"];
  // }

  Customer.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    this._id = snapshot.id;
    this._name = snapshot.get('name');
    this._customerRegisterdOn = snapshot.get('registeredOn');
    this._mobileNumber = snapshot.get('mobile');
    this._customerId = snapshot.get('customerId');
    this._deliveryPersonId = snapshot.get('deliveryPersonId');
    this._deliveryPersonName = snapshot.get("deliveryPersonName");
    this._active = snapshot.get("active");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "registeredOn": _customerRegisterdOn,
      "mobile": _mobileNumber,
      "userType": "customer",
      "customerId": _customerId,
      "deliveryPersonId": _deliveryPersonId,
      "deliveryPersonName": _deliveryPersonName,
      "active": _active
    };
  }
}
