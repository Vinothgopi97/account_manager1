import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/NewBillPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewCustomers extends StatefulWidget {
  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  
  DatabaseReference _databaseReference;



  String selected;
  @override
  void initState() {
    _databaseReference =
        FirebaseDatabase.instance.reference().child("customer");
//    getCount().then((length) =>
//    {
//      print(length),
//        setState(() {
//        selected = List.filled(length, "0.5");
//      }),
    print(selected);
    super.initState();
  }

   Future<int> getCount() async {
    return await _databaseReference.onValue.length;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FirebaseAnimatedList(
            shrinkWrap: true,
            query: _databaseReference.orderByKey(),
            itemBuilder: (context,snapshot,animation,index){
              Customer customer = Customer.fromSnapshot(snapshot);
              return Card(
                child: ListTile(
                  title: Text(customer.name),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: SizedBox(
                      width: 30,
                      child: Text(customer.customerId, style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      IconButton(icon: Icon(Icons.add), onPressed: ()=>{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewBillPage(customer.customerId, customer.name)
                          ),
                        )
                      })
                    ],
                  ),
//                  onTap: ()=>{
//                    Navigator.of(context).push(
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              ViewDeliveryPerson(deliveryPerson.id)
//                      ),
//                    )
//                  },
                ),
              );
            }
        ),
      ),
    );
  }
}
