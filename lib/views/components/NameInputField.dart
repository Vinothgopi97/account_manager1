import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {

  Function onSave;

  NameInputField(Function save){
    onSave = save;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.account_circle, color: Theme.of(context).iconTheme.color,),
        title: TextFormField(
          decoration: InputDecoration(
              hintText: "Name"
          ),
          showCursor: true,
          validator: (input){
            if(input.length < 1)
              return "Enter Name";
          },
          onSaved: onSave,
        )
    );
  }
}
