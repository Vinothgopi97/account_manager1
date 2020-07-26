import 'package:account_manager/views/CreateCustomerAccountPage.dart';
import 'package:account_manager/views/CreateDeliveryPersonAccountPage.dart';
import 'package:account_manager/views/DeliveryPersonHomePage.dart';
import 'package:account_manager/views/HomePage.dart';
import 'package:account_manager/views/SigninPage.dart';
import 'package:account_manager/views/ViewCustomers.dart';
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
          color: Colors.purple,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20,
                color: Colors.white
            )
          )
        ),
        primarySwatch: Colors.purple,
        accentColor: Colors.purpleAccent,
        cursorColor: Colors.purple,
        iconTheme: IconThemeData(
          color: Colors.purple
        ),
        backgroundColor: Colors.purple,
        buttonColor: Colors.purple,
        splashColor: Colors.red,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          buttonColor: Colors.purple,
          splashColor: Colors.red,
        ),
        primaryColor: Colors.purple,
        cardTheme: CardTheme(
          margin: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20
          )
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.purple
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
        "/viewcustomers": (builder) => ViewCustomers(),
      },
    );
  }
}
