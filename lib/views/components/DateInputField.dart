import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {

  Function callback;

  String hint;

  FocusNode current;
  FocusNode next;


  DateInputField(this.callback, this.hint, this.current, this.next);

  @override
  _DateInputFieldState createState() => _DateInputFieldState(this.hint, this.callback, this.current, this.next,);
}

class _DateInputFieldState extends State<DateInputField> {
  Function callback;

  FocusNode current;
  FocusNode next;

  String hint;

  DateTime date = DateTime.now();


  _DateInputFieldState( this.hint,this.callback, this.current, this.next);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range,color: Theme.of(context).iconTheme.color,),
      title: DateTimeFormField(
        decoration: InputDecoration(
          hintText: hint,
          labelText: hint
        ),
        mode: DateFieldPickerMode.date,
        onSaved: (val){
          callback(DateFormat('yyyy-MM-dd').format(val).toString());
        },
        onDateSelected: (DateTime date1) {
          setState(() {
            date = date1;
          });
          if(next != null)
            next.requestFocus();
        },
        lastDate: DateTime.now(),
        initialValue: date,
      ),

    );
  }
}
