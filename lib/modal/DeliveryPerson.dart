import 'package:firebase_database/firebase_database.dart';

class DeliveryPerson{

  String _id;
  String _name;
  String _email;
  String _dateOfBirth;
  String _registeredOn;
  String _mobileNumber;
  String _address;

  String get registeredOn => _registeredOn;

  set registeredOn(String value) {
    _registeredOn = value;
  }

  DeliveryPerson(this._name, this._email, this._dateOfBirth, this._mobileNumber,this._registeredOn,
      this._address);

  DeliveryPerson.withId(this._id,this._name, this._email, this._dateOfBirth,
      this._mobileNumber,this._registeredOn, this._address);


  @override
  String toString() {
    return 'DeliveryPerson{_name: $_name, _email: $_email, _dateOfBirth: $_dateOfBirth, _registeredOn: $_registeredOn, _mobileNumber: $_mobileNumber, _address: $_address}';
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get mobileNumber => _mobileNumber;

  set mobileNumber(String value) {
    _mobileNumber = value;
  }

  String get dateOfBirth => _dateOfBirth;

  set dateOfBirth(String value) {
    _dateOfBirth = value;
  }

  set email(String value) {
    _email = value;
  }

  DeliveryPerson.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._dateOfBirth = snapshot.value['dataOfBirth'];
    this._registeredOn = snapshot.value['registeredOn'];
    this._mobileNumber = snapshot.value['mobile'];
    this._address = snapshot.value['address'];
    this._email = snapshot.value['email'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name" : _name,
      "registeredOn" : _registeredOn,
      "dataOfBirth" : _dateOfBirth,
      "mobile" : _mobileNumber,
      "address" : _address,
      "email" : _email,
      "userType" : "deliveryPerson"
    };
  }

}