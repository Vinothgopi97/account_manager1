import 'package:flutter/material.dart';

class AddressInputFiled extends StatelessWidget {

  Function callback;

  String address;

  AddressInputFiled(this.callback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.location_city, color: Theme.of(context).iconTheme.color,),
        title: TextFormField(
          decoration: InputDecoration(
              hintText: "Address"
          ),
          showCursor: true,
          validator: (input){
            if(input.length <= 3)
              return "Enter a valid address";
          },
          onSaved: callback,
        )
    );;
  }
}
