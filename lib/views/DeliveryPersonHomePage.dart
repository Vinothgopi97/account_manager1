import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryPersonHome extends StatefulWidget {
  @override
  _DeliveryPersonHomeState createState() => _DeliveryPersonHomeState();
}

class _DeliveryPersonHomeState extends State<DeliveryPersonHome> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedin = false;

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
    super.initState();
    isSignedin = false;
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Person", style: Theme.of(context).appBarTheme.textTheme.headline1,),
      ),
      body: isSignedin? Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(isSignedin ? user.email : "Loading..."),
              RaisedButton(onPressed: signout, child: Text("Signout",style: Theme.of(context).textTheme.button,),),

              RaisedButton(onPressed: gotoViewCustomerPage, child: Text("View Customers",style: Theme.of(context).textTheme.button,),),

            ],
          )
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}