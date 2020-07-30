import 'package:account_manager/views/CreateCustomerAccountPage.dart';
import 'package:account_manager/views/CreateDeliveryPersonAccountPage.dart';
import 'package:account_manager/views/DeliveryPersonHomePage.dart';
import 'package:account_manager/views/HomePage.dart';
import 'package:account_manager/views/SigninPage.dart';
import 'package:account_manager/views/ViewDeliveryPersons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Manager',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20,
                color: Colors.white
            )
          )
        ),
        primarySwatch: Colors.lightBlue,
        secondaryHeaderColor: Colors.lightBlueAccent,
        accentColor: Colors.lightBlueAccent,
        cursorColor: Colors.lightBlue,
        iconTheme: IconThemeData(
          color: Colors.lightBlueAccent
        ),
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
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
          )
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.lightBlue
          ),
          headline2: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.black54
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 15,
          )

        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SigninPage(),
      routes: <String,WidgetBuilder> {
        "/signin": (builder) => SigninPage(),
        "/adminhome": (builder) => Home(),
        "/deliveryhome": (builder) => DeliveryPersonHome(),
        "/createdeliveryperson": (builder) => CreateDeliveryPersonAccountPage(),
        "/viewdeliverypersons": (builder) => ViewDeliveryPersons(),
        "/createcustomer": (builder) => CreateCustomerAccountPage(),
      },
    );
  }
}
