import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).appBarTheme.textTheme.headline1,),
      ),
      body: Container(
        child: Center(
          child: Text(username != null ? username : "No Data"),
        ),
      ),
    );
  }


}
