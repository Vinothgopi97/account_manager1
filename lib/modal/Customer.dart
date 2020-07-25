class Customer{

  String _name;
  DateTime _customerRegisterdOn;
  String _mobileNumber;
  String _address;

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

  Customer.newCustomer(this._name, this._customerRegisterdOn, this._mobileNumber, this._address);
}