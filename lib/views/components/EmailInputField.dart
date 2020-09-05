// import 'package:flutter/material.dart';
//
// class EmailInputField extends StatelessWidget {
//   final RegExp emailRegExp = new RegExp("[a-z0-9]+\@[a-z]+\.[a-z]+");
//
//   final Function onSave;
//   final FocusNode current;
//   final FocusNode next;
//
//   EmailInputField(this.onSave, this.current, this.next);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         leading: Icon(
//           Icons.email,
//           color: Theme.of(context).iconTheme.color,
//         ),
//         title: TextFormField(
//           focusNode: current,
//           decoration: InputDecoration(hintText: "Email Id"),
//           showCursor: true,
//           keyboardType: TextInputType.emailAddress,
//           validator: (input) {
//             if (!emailRegExp.hasMatch(input)) return "Enter a valid email id";
//           },
//           onSaved: onSave,
//           onEditingComplete: next != null ? () => next.requestFocus() : null,
//         ));
//   }
// }
