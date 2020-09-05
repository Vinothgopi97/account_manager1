import 'package:account_manager/common/MessageApi.dart';
import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/modal/DeliveryPerson.dart';
import 'package:account_manager/views/NewBillPage.dart';
import 'package:account_manager/views/components/AddBillDialouge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isSignedin = false;
  Map<String, double> price = {};
  List<String> liters;
  String selected;
  MessageApi messageApi;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushNamed("/signin");
      }
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    price = {};
    isSignedin = false;
    this.checkAuthentication();
    this.getUser();
    messageApi = MessageApi();
    getPriceList();
    super.initState();
  }

  getPriceList() async {
    FirebaseFirestore.instance
        .collection("config")
        .doc("price")
        .snapshots()
        .listen((event) {
      event.data().forEach((key, value) {
        String k = key.replaceAll('point', '.');
        double val = double.parse(value.toString());
        price.putIfAbsent(k, () => val);
      });
      liters = price.keys.toList();
      setState(() {
        selected = liters.elementAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text(
                    "Customers",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    "Delivery Persons",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
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
          body: TabBarView(children: [
            Scaffold(
              body: isSignedin
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("customers")
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
                                return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.lightBlueAccent,
                                      child: Text(
                                        customer.customerId,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      customer.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Text("Delivery by: " +
                                        customer.deliveryPersonName),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            onPressed: () => {
                                                  showAddBillDialouge(customer)
                                                }),
                                        IconButton(
                                            icon: Icon(Icons.add_circle),
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            onPressed: () => {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewBillPage(
                                                                customer,
                                                                price,
                                                                true)),
                                                  )
                                                })
                                      ],
                                    ));
                              });
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: gotoCreateCustomerPage,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  "Customer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Scaffold(
              body: isSignedin
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("deliverypersons")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Text("Loading...");
                        else
                          return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DeliveryPerson deliveryperson =
                                    DeliveryPerson.fromQuerySnapshot(
                                        snapshot.data.documents[index]);

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: Text(
                                      deliveryperson.deliveryPersonId,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    deliveryperson.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(deliveryperson.mobileNumber),
                                );
                              });
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: gotoCreateDeliveryPersonPage,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  "Delivery Person",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ));
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
}
