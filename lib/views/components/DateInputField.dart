import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {

  Function callback;

  String hint;

  DateInputField(this.hint, this.callback);

  @override
  _DateInputFieldState createState() => _DateInputFieldState(this.hint, this.callback);
}

class _DateInputFieldState extends State<DateInputField> {
  Function callback;

  String hint;

  DateTime date = DateTime.now();

  _DateInputFieldState(this.hint,this.callback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range,color: Theme.of(context).iconTheme.color,),
      title: DateTimeFormField(
        mode: DateFieldPickerMode.date,
        onSaved: (val){
          callback(DateFormat('yyyy-MM-dd').format(val).toString());
        },
        onDateSelected: (DateTime date1) {
          setState(() {
            date = date1;
          });
        },
        lastDate: DateTime.now(),
        initialValue: date,
      ),

    );
  }
}
