import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final Function onSave;
  final FocusNode current;
  final FocusNode next;

  NameInputField(this.onSave, this.current, this.next);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.account_circle,
          color: Theme.of(context).iconTheme.color,
        ),
        title: TextFormField(
          focusNode: current,
          decoration: InputDecoration(hintText: "Name"),
          showCursor: true,
          validator: (input) {
            if (input.length < 1) return "Enter Name";
          },
          onSaved: onSave,
          onEditingComplete: () => next != null ? next.requestFocus() : null,
        ));
  }
}
