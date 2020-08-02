import 'package:firebase_database/firebase_database.dart';

class DeliveryPerson{

  String _id;
  String _deliveryPersonId;
  String _name;

  String _registeredOn;
  String _mobileNumber;


  String get deliveryPersonId => _deliveryPersonId;

  set deliveryPersonId(String value) {
    _deliveryPersonId = value;
  }

  String get registeredOn => _registeredOn;

  set registeredOn(String value) {
    _registeredOn = value;
  }

  DeliveryPerson(this._deliveryPersonId,this._name,  this._mobileNumber,this._registeredOn);

  DeliveryPerson.withId(this._id,this._deliveryPersonId,this._name,
      this._mobileNumber,this._registeredOn);


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

  DeliveryPerson.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._deliveryPersonId = snapshot.value['deliveryPersonId'];
//    this._dateOfBirth = snapshot.value['dataOfBirth'];
    this._registeredOn = snapshot.value['registeredOn'];
    this._mobileNumber = snapshot.value['mobile'];
//    this._address = snapshot.value['address'];
//    this._email = snapshot.value['email'];
//    this._createdBy = snapshot.value['createdBy'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : _name,
    "deliveryPersonId":_deliveryPersonId,

      "registeredOn" : _registeredOn,
//      "dataOfBirth" : _dateOfBirth,
      "mobile" : _mobileNumber,
//      "address" : _address,
//      "email" : _email,
      "userType" : "deliveryPerson",
//      "createdBy" : _createdBy,
    };
  }

}