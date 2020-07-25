class DeliveryPerson{
  String _name;
  String _email;
  String _dateOfBirth;
  String _mobileNumber;
  String _address;

  DeliveryPerson(this._name, this._email, this._dateOfBirth, this._mobileNumber,
      this._address);

  DeliveryPerson.newDeliveryPerson(this._name, this._email, this._dateOfBirth,
      this._mobileNumber, this._address);

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
}