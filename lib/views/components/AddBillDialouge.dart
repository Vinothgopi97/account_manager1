import 'package:account_manager/common/MessageApi.dart';
import 'package:account_manager/modal/Bill.dart';
import 'package:account_manager/modal/Customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBillDialouge extends StatefulWidget {
  final Customer _customer;
  final Map<String, double> _priceList;

  AddBillDialouge(this._customer, this._priceList);

  @override
  _AddBillDialougeState createState() =>
      _AddBillDialougeState(this._customer, this._priceList);
}

class _AddBillDialougeState extends State<AddBillDialouge> {
  Customer _customer;
  Map<String, double> _priceList;
  String selected;
  String billIdKeyString;
  MessageApi messageApi;
  double total;
  List<String> liters;
  _AddBillDialougeState(this._customer, this._priceList);

  @override
  void initState() {
    selected = _priceList.keys.toList().elementAt(0);
    total = 0.0;
    messageApi = MessageApi();
    liters = _priceList.keys.toList();
    setState(() {
      selected = liters.elementAt(0);
    });
    billIdKeyString = _customer.customerId +
        "_" +
        DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString();
    getTotalBill(billIdKeyString).then((value) => {
          setState(() {
            total = value;
          })
        });
    super.initState();
  }

  Future<double> getTotalBill(String billIdKeyString1) async {
    double total = 0.0;
    List<QueryDocumentSnapshot> list;
    await FirebaseFirestore.instance
        .collection("bills")
        .where("billId", isEqualTo: billIdKeyString1)
        .get()
        .then((value) => {
              list = value.docs,
              list.forEach((element) {
                total += element.get("billamount");
              }),
            });
    return total;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Customer Name: " + _customer.name),
        // Text("Total Bill - ₹" + total.toString()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Lliters delivered"),
            DropdownButton<String>(
              items: liters.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(
                    value: e.toString(),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(e.toString()),
                      ],
                    ));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  selected = e.toString();
                });
              },
              value: selected,
            ),
          ],
        ),
        Row(
          children: [
            FlatButton(
                onPressed: () => {addBill(_customer, selected, total)},
                child: Text("Add Bill")),
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"))
          ],
        )
      ],
    );
  }

  addBill(Customer customer, String liters, double total) async {
    int oldid = 0;
    double oldTotal = total;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    Bill bill = Bill(customer.customerId, customer.name, double.parse(liters),
        _priceList[liters], date);
    String text = "Milk bill on " +
        date +
        "\nExisting:₹" +
        oldTotal.toString() +
        "\nNew:₹" +
        _priceList[liters].toString() +
        "\nTotal: ₹" +
        (oldTotal + _priceList[liters]).toString();

    await FirebaseFirestore.instance
        .collection("config")
        .doc("bill")
        .get()
        .then((value) => {oldid = value.get("nextId")});
    await FirebaseFirestore.instance
        .collection("bills")
        .doc(oldid.toString())
        .set(bill.toJson())
        .whenComplete(() => {
              FirebaseFirestore.instance
                  .collection("config")
                  .doc("bill")
                  .set({"nextId": oldid + 1}),
              messageApi
                  .sendMessage(text, "91" + customer.mobileNumber)
                  .then((value) => {
                        if (value["status"] == "success")
                          showSuccess("Message sent: " + text)
                        else
                          showError("Bill added but message not sent\n\"" +
                              value["errors"][0]["message"] +
                              "\"")
                      }),
            })
        .catchError((err) => {showError(err.message)});
  }

  showError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
              onPressed: () =>
                  {Navigator.of(context).pop(), Navigator.of(context).pop()},
              child: Text("OK"))
        ],
      ),
    );
  }

  showSuccess(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Success"),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
              onPressed: () =>
                  {Navigator.of(context).pop(), Navigator.of(context).pop()},
              child: Text("OK"))
        ],
      ),
    );
  }
}
