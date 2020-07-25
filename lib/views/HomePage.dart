import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

  signup(){
    Navigator.pushNamed(context, "/signup");
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
        title: Text("Home", style: Theme.of(context).appBarTheme.textTheme.headline1,),
      ),
      body: isSignedin? Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(isSignedin ? user.email : "Loading..."),
              RaisedButton(onPressed: signout, child: Text("Signout",style: Theme.of(context).textTheme.button,),),
              RaisedButton(onPressed: signup, child: Text("SignUp",style: Theme.of(context).textTheme.button,),)
            ],
          )
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}