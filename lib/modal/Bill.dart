import 'package:firebase_database/firebase_database.dart';

class Bill{
  String _id;
  String _customerId;
  String _customerName;
  double _litersDelivered;
  double _price;
  String _billCreatedBy;
  String _billDate;


  String get billCreatedBy => _billCreatedBy;

  set billCreatedBy(String value) {
    _billCreatedBy = value;
  }


  Bill(this._customerId, this._customerName, this._litersDelivered, this._price,
      this._billCreatedBy, this._billDate);

  Bill.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._customerId = snapshot.value['customerId'];
    this._customerName = snapshot.value['customerName'];
    this._litersDelivered = snapshot.value['litersDelivered'];
    this._price = snapshot.value['billamount'];
    this._billCreatedBy = snapshot.value['billCreatedBy'];
    this._billDate = snapshot.value['billDate'];
  }

  Map<String,dynamic> toJson(){
    return {
      "customerId" : _customerId,
      "customerName" : _customerName,
      "litersDelivered" : _litersDelivered,
      "billamount" : _price,
      "billCreatedBy": _billCreatedBy,
      "billDate": _billDate
    };
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get customerId => _customerId;

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  double get litersDelivered => _litersDelivered;

  set litersDelivered(double value) {
    _litersDelivered = value;
  }

  String get customerName => _customerName;

  set customerName(String value) {
    _customerName = value;
  }

  set customerId(String value) {
    _customerId = value;
  }

  String get billDate => _billDate;

  set billDate(String value) {
    _billDate = value;
  }
}