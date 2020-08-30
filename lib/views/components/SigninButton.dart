import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {

  final Function _fun;

  SigninButton(this._fun);

  @override
  Widget build(BuildContext context) {
    return  ButtonTheme(
      height: 40.0,
      minWidth: 200.0,
      child: RaisedButton(
        onPressed: _fun,
        color: Theme.of(context).buttonColor,
        child: Text("Sign In",style: Theme.of(context).textTheme.button,),
      ),
    );
  }

}
