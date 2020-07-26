import 'package:flutter/material.dart';

class MobileNumberInputField extends StatelessWidget {

  final RegExp mobileRegExp = new RegExp("[0-9]{10}");

  Function onSave;

  MobileNumberInputField(Function save){
    onSave = save;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.phone, color: Theme.of(context).iconTheme.color,),
        title: TextFormField(
          decoration: InputDecoration(
              hintText: "Mobile"
          ),
          showCursor: true,
          validator: (input){
            if(!mobileRegExp.hasMatch(input))
              return "Enter a valid mobile number";
          },
          onSaved: onSave,
        )
    );
  }
}
