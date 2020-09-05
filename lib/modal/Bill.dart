import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';

class Bill {
  String _id;
  String _billId;
  String _customerId;
  String _customerName;
  double _litersDelivered;
  double _price;
  String _billDate;

  String get billId => _billId;

  set billId(String value) {
    _billId = value;
  }

  Bill(this._customerId, this._customerName, this._litersDelivered, this._price,
      this._billDate);

  Bill.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    this._id = snapshot.id;
    this._customerId = snapshot.get('customerId');
    this._customerName = snapshot.get('customerName');
    this._litersDelivered =
        double.parse(snapshot.get('litersDelivered').toString());
    this._price = double.parse(snapshot.get('billamount').toString());
    this._billDate = snapshot.get('billDate');
    this._billId = snapshot.get("billId");
  }

  // Bill.fromSnapshot(DataSnapshot snapshot) {
  //   this._id = snapshot.key;
  //   this._customerId = snapshot.value['customerId'];
  //   this._customerName = snapshot.value['customerName'];
  //   this._litersDelivered =
  //       double.parse(snapshot.value['litersDelivered'].toString());
  //   this._price = double.parse(snapshot.value['billamount'].toString());
  //   this._billDate = snapshot.value['billDate'];
  //   this._billId = snapshot.value["billId"];
  // }

  Map<String, dynamic> toJson() {
    return {
      "customerId": _customerId,
      "customerName": _customerName,
      "litersDelivered": _litersDelivered,
      "billamount": _price,
      "billDate": _billDate,
      "billId": _customerId +
          "_" +
          DateTime.parse(_billDate).year.toString() +
          "-" +
          DateTime.parse(_billDate).month.toString()
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
