import 'dart:collection';

import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/modal/DeliveryPerson.dart';
import 'package:account_manager/views/NewBillPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DeliveryPersonHome extends StatefulWidget {

  String _deliveryPersonId;


  DeliveryPersonHome(this._deliveryPersonId);

  @override
  _DeliveryPersonHomeState createState() => _DeliveryPersonHomeState(this._deliveryPersonId);
}

class _DeliveryPersonHomeState extends State<DeliveryPersonHome> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedin = false;
  String _deliveryPersonId;
  DeliveryPerson _deliveryPerson;


  DatabaseReference _databaseReference;

  _DeliveryPersonHomeState(this._deliveryPersonId);

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
  Map<String,double> price = {};

  getPriceList() async {
    LinkedHashMap priceList;
    await _databaseReference.child("config").child("price").onValue.listen((event) {
      priceList = event.snapshot.value;
      priceList.forEach((key, value) {
        String k = key.replaceAll('point', '.');
        double val = double.parse(value.toString());
        price.putIfAbsent(k, () => val);
      });
    });
  }

  logout(){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are You Sure"),
        content: Text("Are you sure to signout."),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("No")),
          FlatButton(onPressed: signout, child: Text("Yes"))
        ],
      ),
    );
  }

  @override
  void initState() {

    isSignedin = false;
    _databaseReference = FirebaseDatabase.instance.reference();
    _databaseReference.child("deliveryperson").child(_deliveryPersonId).onValue.listen((event) {
      _deliveryPerson = DeliveryPerson.fromSnapshot(event.snapshot);
    });
    this.checkAuthentication();
    this.getPriceList();
    this.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Milk Bill Manager", style: Theme.of(context).appBarTheme.textTheme.headline1,),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.lock,color: Colors.white,), onPressed: logout),
        ],
      ),
      body: isSignedin? FirebaseAnimatedList(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 5),
          query: _databaseReference.child("customer").orderByChild("deliveryPersonId").equalTo(_deliveryPersonId),
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
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:5),child: Text(customer.mobileNumber),),
                    Padding(padding: EdgeInsets.only(top:5),child: Text("Delivery person: "+customer.deliveryPersonName),),

                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(customer.customerId, style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.add_circle),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: ()=>{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewBillPage(customer,price,false)
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
    );
  }
}