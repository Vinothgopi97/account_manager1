import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {

  Function onSave;

  PasswordInputField(Function save){
    onSave = save;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.vpn_key, color: Theme.of(context).iconTheme.color),
        title: TextFormField(
          decoration: InputDecoration(
              hintText: "Password",
          ),
          showCursor: true,
          obscureText: true,
          validator: (input){
            if(input.length < 8)
              return "Password must be atleast 8 characters long";
          },
          onSaved: onSave,
        )
    );
  }
}
