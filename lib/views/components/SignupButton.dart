import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {

  final Function _fun;

  SignupButton(this._fun);

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
