import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {

  final RegExp emailRegExp = new RegExp("[a-z0-9]+\@[a-z]+\.[a-z]+");

  Function onSave;

  EmailInputField(Function save){
    onSave = save;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.email, color: Theme.of(context).iconTheme.color,),
        title: TextFormField(
          decoration: InputDecoration(
              hintText: "Email Id"
          ),
          showCursor: true,
          validator: (input){
            if(!emailRegExp.hasMatch(input))
              return "Enter a valid email id";
          },
          onSaved: onSave,
        )
    );
  }
}
