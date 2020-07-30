import 'dart:collection';

import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/NewBillPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  DatabaseReference _databaseReference;
  DatabaseReference _configDatabaseReference;
  bool isSignedin = false;
  Map<String,double> price = {};

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if(user == null){
        Navigator.of(context).pushReplacementNamed("/signin");
      }
    });
  }

  getUser() async{
    FirebaseUser firebaseuser = await _auth.currentUser();
    await firebaseuser?.reload();
    firebaseuser = await _auth.currentUser();
    if(firebaseuser != null){
      setState(() {
        this.user = firebaseuser;
        this.isSignedin = true;
      });
    }
  }



  signout() async{
    _auth.signOut();
  }

  gotoCreateDeliveryPersonPage(){
    Navigator.pushNamed(context, "/createdeliveryperson");
  }

  gotoCreateCustomerPage(){
    Navigator.pushNamed(context, "/createcustomer");
  }

  gotoViewCustomerPage(){
    Navigator.pushNamed(context, "/viewcustomers");
  }

  @override
  void initState() {
    price = {};
    isSignedin = false;
    this.checkAuthentication();
    this.getUser();
    _databaseReference = FirebaseDatabase.instance.reference().child("customer");
    _configDatabaseReference = FirebaseDatabase.instance.reference().child("config");
    getPriceList();
    super.initState();
  }

  getPriceList() async {
    LinkedHashMap priceList;
    await _configDatabaseReference.child("price").onValue.listen((event) {
      priceList = event.snapshot.value;
      priceList.forEach((key, value) {
        String k = key.replaceAll('point', '.');
        double val = double.parse(value.toString());
        price.putIfAbsent(k, () => val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Customers", style: Theme.of(context).appBarTheme.textTheme.headline1,),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.lock,color: Colors.white,), onPressed: signout),
        ],
      ),
      body: isSignedin? FirebaseAnimatedList(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 5),
          query: _databaseReference.orderByKey(),
          defaultChild: Center(child: CircularProgressIndicator(),),
          itemBuilder: (context,snapshot,animation,index){
            Customer customer = Customer.fromSnapshot(snapshot);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.0),
                    top: Radius.circular(2.0)),
              ),
              margin: EdgeInsets.all(5),
              child: ListTile(
                dense: true,
                title: Text(customer.name,style: TextStyle(fontSize: 20,letterSpacing: 0.9),),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(customer.customerId, style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.add),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: ()=>{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewBillPage(customer.customerId, customer.name,customer.mobileNumber,price)
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
      ) : Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: gotoCreateCustomerPage, child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}