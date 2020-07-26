import 'package:account_manager/modal/DeliveryPerson.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDeliveryPerson extends StatefulWidget {

  String _id;

  ViewDeliveryPerson(this._id);

  @override
  _ViewDeliveryPersonState createState() => _ViewDeliveryPersonState(this._id);
}

class _ViewDeliveryPersonState extends State<ViewDeliveryPerson> {

  String _id;

  _ViewDeliveryPersonState(this._id);

  DatabaseReference _databaseReference;

  bool isLoaded = false;

  DeliveryPerson _deliveryPerson;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child("deliveryperson");
    getDeliveryPerson();
  }

  getDeliveryPerson() async {
    await _databaseReference.child(_id).onValue.listen((event) {
      _deliveryPerson = DeliveryPerson.fromSnapshot(event.snapshot);
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Delivery Person"),
      ),
      body: isLoaded ? Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Name :", style: Theme.of(context).textTheme.headline2,),
                    Text(_deliveryPerson.name, style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Email :", style: Theme.of(context).textTheme.headline2,),
                    Text(_deliveryPerson.email , style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Mobile :", style: Theme.of(context).textTheme.headline2,),
                    Text(_deliveryPerson.mobileNumber , style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Date of Birth :", style: Theme.of(context).textTheme.headline2,),
                    Text(_deliveryPerson.dateOfBirth, style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Address :", style: Theme.of(context).textTheme.headline2,),
                    Text(_deliveryPerson.address, style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Registered on :", style: Theme.of(context).textTheme.headline2,),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(_deliveryPerson.registeredOn)).toString(), style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Text("Registered by :", style: Theme.of(context).textTheme.headline2,),
                Text(_deliveryPerson.createdBy, style: Theme.of(context).textTheme.headline2,),
              ],
            ),
          ),
    ): CircularProgressIndicator()
    );
  }
}
