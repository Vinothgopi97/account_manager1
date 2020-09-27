import 'package:account_manager/views/CreateCustomerAccountPage.dart';
import 'package:account_manager/views/CreateDeliveryPersonAccountPage.dart';
import 'package:account_manager/views/HomePage.dart';
import 'package:account_manager/views/SigninPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> checkAndGrantPermissions(BuildContext context) async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.checkPermissions([Permission.SEND_SMS]);
    if (permission[Permission.SEND_SMS] != PermissionState.GRANTED) {
      try {
        permission =
            await PermissionsPlugin.requestPermissions([Permission.SEND_SMS]);
      } on Exception {
        debugPrint("Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAndGrantPermissions(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account Manager',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            color: Colors.lightBlue,
            textTheme: TextTheme(
                headline1: TextStyle(fontSize: 20, color: Colors.white))),
        primarySwatch: Colors.lightBlue,
        secondaryHeaderColor: Colors.lightBlueAccent,
        accentColor: Colors.lightBlueAccent,
        cursorColor: Colors.lightBlue,
        iconTheme: IconThemeData(color: Colors.lightBlueAccent),
        backgroundColor: Colors.lightBlue,
        buttonColor: Colors.lightBlueAccent,
        splashColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          buttonColor: Colors.lightBlue,
          splashColor: Colors.blue,
        ),
        primaryColor: Colors.lightBlue,
        cardTheme: CardTheme(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.lightBlue),
            headline2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.black54),
            button: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SigninPage(),
      routes: <String, WidgetBuilder>{
        "/signin": (builder) => SigninPage(),
        "/adminhome": (builder) => Home(),
        "/createdeliveryperson": (builder) => CreateDeliveryPersonAccountPage(),
        "/createcustomer": (builder) => CreateCustomerAccountPage(),
      },
    );
  }
}
