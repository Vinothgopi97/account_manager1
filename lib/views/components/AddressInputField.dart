// import 'package:flutter/material.dart';
//
// class AddressInputFiled extends StatelessWidget {
//   final Function callback;
//   final FocusNode current;
//   final FocusNode next;
//
//   AddressInputFiled(this.callback, this.current, this.next);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         leading: Icon(
//           Icons.location_city,
//           color: Theme.of(context).iconTheme.color,
//         ),
//         title: TextFormField(
//           focusNode: current,
//           decoration: InputDecoration(hintText: "Address"),
//           showCursor: true,
//           validator: (input) {
//             if (input.length <= 3) return "Enter a valid address";
//           },
//           onSaved: callback,
//           onEditingComplete: next != null ? () => next.requestFocus() : null,
//         ));
//   }
// }
