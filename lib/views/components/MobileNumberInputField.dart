import 'package:flutter/material.dart';

class MobileNumberInputField extends StatelessWidget {

  final RegExp mobileRegExp = new RegExp("[0-9]{10}");

  Function onSave;

  FocusNode current;
  FocusNode next;


  MobileNumberInputField(this.onSave, this.current, this.next);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.phone, color: Theme.of(context).iconTheme.color,),
        title: TextFormField(
          maxLength: 10,
          focusNode: current,
          decoration: InputDecoration(
              hintText: "Mobile"
          ),
          keyboardType: TextInputType.phone,
          showCursor: true,
          validator: (input){
            if(!mobileRegExp.hasMatch(input) && input.length != 10)
              return "Enter a valid mobile number";
          },
          onSaved: onSave,
          onEditingComplete: ()=> next!= null ? next.requestFocus() : null,
        )
    );
  }
}
