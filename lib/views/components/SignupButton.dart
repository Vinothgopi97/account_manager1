import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  GlobalKey<FormState> _key;
  Function _fun;

  SignupButton(GlobalKey key, Function fun){
    _key = key;
    _fun = fun;
  }

  @override
  Widget build(BuildContext context) {
    return  ButtonTheme(
      height: 40.0,
      minWidth: 200.0,
      child: RaisedButton(
        onPressed: _fun,
        color: Theme.of(context).buttonColor,
        child: Text("Create",style: Theme.of(context).textTheme.button,),
      ),
    );
  }

}
