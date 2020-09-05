import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/modal/DeliveryPerson.dart';
import 'package:account_manager/views/NewBillPage.dart';
import 'package:account_manager/views/components/AddBillDialouge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryPersonHome extends StatefulWidget {
  final String _deliveryPersonId;

  DeliveryPersonHome(this._deliveryPersonId);

  @override
  _DeliveryPersonHomeState createState() =>
      _DeliveryPersonHomeState(this._deliveryPersonId);
}

class _DeliveryPersonHomeState extends State<DeliveryPersonHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isSignedin = false;
  String _deliveryPersonId;
  DeliveryPerson _deliveryPerson;

  // DatabaseReference _databaseReference;

  _DeliveryPersonHomeState(this._deliveryPersonId);

  @override
  void dispose() {
    super.dispose();
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushReplacementNamed("/signin");
      }
    });
  }

  showAddBillDialouge(Customer customer) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Add Bill"),
        content: AddBillDialouge(customer, price),
      ),
    );
  }

  getUser() async {
    User firebaseuser = _auth.currentUser;
    await firebaseuser?.reload();
    firebaseuser = _auth.currentUser;
    if (firebaseuser != null) {
      setState(() {
        this.user = firebaseuser;
        this.isSignedin = true;
      });
    }
  }

  signout() async {
    _auth.signOut();
  }

  gotoCreateDeliveryPersonPage() {
    Navigator.pushNamed(context, "/createdeliveryperson");
  }

  gotoCreateCustomerPage() {
    Navigator.pushNamed(context, "/createcustomer");
  }

  gotoViewCustomerPage() {
    Navigator.pushNamed(context, "/viewcustomers");
  }

  Map<String, double> price = {};

  getPriceList() async {
    Map<String, dynamic> priceList;
    await FirebaseFirestore.instance
        .collection("config")
        .doc("price")
        .get()
        .then((value) => {
              priceList = value.data(),
              priceList.forEach((key, value) {
                String k = key.replaceAll('point', '.');
                double val = double.parse(value.toString());
                price.putIfAbsent(k, () => val);
              }),
            });
  }

  logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are You Sure"),
        content: Text("Are you sure to signout."),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("No")),
          FlatButton(onPressed: signout, child: Text("Yes"))
        ],
      ),
    );
  }

  @override
  void initState() {
    isSignedin = false;
    getDeliveryPerson();
    this.checkAuthentication();
    this.getPriceList();
    this.getUser();
    super.initState();
  }

  getDeliveryPerson() async {
    print(_deliveryPersonId);
    await FirebaseFirestore.instance
        .collection("deliverypersons")
        .doc(_deliveryPersonId)
        .get()
        .then((value) => {
              print(value.data()),
              _deliveryPerson = DeliveryPerson.fromQuerySnapshot(value),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Milk Bill Manager",
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              onPressed: logout),
        ],
      ),
      body: user != null
          ? Container(
              height: 300,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("customers")
                      .where("deliveryPersonId", isEqualTo: _deliveryPersonId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text("Loading...");
                    else
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            Customer customer =
                                Customer.fromQueryDocumentSnapshot(
                                    snapshot.data.documents[index]);

                            return Card(
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  customer.name,
                                  style: TextStyle(
                                      fontSize: 20, letterSpacing: 0.9),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(customer.mobileNumber),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(top: 5),
                                    //   child: Text("Delivery person: " +
                                    //       customer.deliveryPersonName),
                                    // ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  child: Text(
                                    customer.customerId,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.message,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        onPressed: () =>
                                            {showAddBillDialouge(customer)}),
                                    IconButton(
                                        icon: Icon(Icons.add_circle),
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        onPressed: () => {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewBillPage(customer,
                                                            price, false)),
                                              )
                                            })
                                  ],
                                ),
                              ),
                            );
                          });
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
