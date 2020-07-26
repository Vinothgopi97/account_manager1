import 'package:account_manager/modal/DeliveryPerson.dart';
import 'package:account_manager/views/ViewDeliveryPerson.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewDeliveryPersons extends StatefulWidget {
  @override
  _ViewDeliveryPersonsState createState() => _ViewDeliveryPersonsState();
}

class _ViewDeliveryPersonsState extends State<ViewDeliveryPersons> {
  
  DatabaseReference _databaseReference;
  
  
  
  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child("deliveryperson");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Persons"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FirebaseAnimatedList(
            shrinkWrap: true,
            query: _databaseReference.orderByKey(),
            itemBuilder: (context,snapshot,animation,index){
              DeliveryPerson deliveryPerson= DeliveryPerson.fromSnapshot(snapshot);
              return Card(
                child: ListTile(
                  title: Text(deliveryPerson.name),
                  subtitle: Text(deliveryPerson.email),
                  onTap: ()=>{
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewDeliveryPerson(deliveryPerson.id)
                      ),
                    )
                  },
                ),
              );
            }
        ),
      ),
    );
  }
}
