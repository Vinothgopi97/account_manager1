import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final Function onSave;
  final FocusNode current;
  final FocusNode next;

  PasswordInputField(this.onSave, this.current, this.next);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.vpn_key, color: Theme.of(context).iconTheme.color),
        title: TextFormField(
          focusNode: current,
          decoration: InputDecoration(
            hintText: "Password",
          ),
          showCursor: true,
          obscureText: true,
          validator: (input) {
            if (input.length < 8)
              return "Password must be atleast 8 characters long";
          },
          onSaved: onSave,
          onEditingComplete: next != null ? () => next.requestFocus() : null,
        ));
  }
}
