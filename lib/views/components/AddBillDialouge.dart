import 'package:account_manager/modal/Bill.dart';
import 'package:account_manager/modal/Customer.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:sms/sms.dart';
// import 'package:sms_plugin/sms.dart';

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
  // MessageApi messageApi;
  double total;
  List<String> liters;
  // SmsSender sender;
  // final Telephony telephony = Telephony.instance;

  _AddBillDialougeState(this._customer, this._priceList);

  void _sendSMS(String message, String recipent) async {
    // List<String> nums = [recipent];
    // String _result =
    //     await FlutterSms.sendSMS(message: message, recipients: nums)
    //         .catchError((onError) {
    //   print(onError);
    // });

    SmsStatus result = await BackgroundSms.sendMessage(
            phoneNumber: recipent, message: message, simSlot: 1)
        .catchError((e) => {showError(e.toString())});

    if (result == SmsStatus.sent) {
      showSuccess("Message Sent: " + message);
    } else {
      print("Failed");
    }

    // SimCardsProvider provider = new SimCardsProvider();
    // List<SimCard> card = await provider.getSimCards();
    // SmsSender sender = new SmsSender();
    // // sender.onSmsDelivered.listen((SmsMessage message) {
    // //   print('${message.address} received your message.');
    // // });
    // SmsMessage message1 = new SmsMessage(recipent, message);
    // sender
    //     .sendSms(message1, simCard: card.elementAt(0))
    //     .then((value) => {showSuccess("Message Sent: " + message)})
    //     .catchError((e) => {showError(e.toString())});
  }

  @override
  void initState() {
    selected = _priceList.keys.toList().elementAt(0);
    total = 0.0;
    // messageApi = MessageApi();
    // sender = new SmsSender();
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Customer: " + _customer.name),
        // Text("Total Bill - ₹" + total.toString()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Liters delivered"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            FlatButton(
                color: Theme.of(context).accentColor,
                onPressed: () => {addBill(_customer, selected, total)},
                child: Text(
                  "Add Bill",
                  style: TextStyle(color: Colors.white),
                )),
            Spacer(),
            FlatButton(
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                )),
            Spacer(),
          ],
        ),
      ],
    );
  }

  addBill(Customer customer, String liters, double total) async {
    int oldid = 0;
    double oldTotal = total;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    Bill bill = Bill(customer.customerId, customer.name, double.parse(liters),
        _priceList[liters], date);
    List<String> mobiles = new List<String>();
    mobiles.add(customer.mobileNumber);
    String text = "Fresz Milk:Bill on " +
        date +
        "\nExisting:₹" +
        oldTotal.toString() +
        "\nNew:₹" +
        _priceList[liters].toString() +
        "\nTotal:₹" +
        (oldTotal + _priceList[liters]).toString();
    // String text =
    //     "\u00b87\u00ba9\u00bcd\u00bb1\u00bc8\u00baf\u0020\u00baa\u00bc1\u00ba4\u00bbf\u00baf\u0020\u00bb0\u00b9a\u00bc0\u00ba4\u00bc1\u003a " +
    //         date;
    // "\nபழையவை:₹" +
    // oldTotal.toString() +
    // "\nபுதியவை:₹" +
    // _priceList[liters].toString() +
    // "\nமொத்தம்:₹" +
    // (oldTotal + _priceList[liters]).toString();

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
              // messageApi
              //     .sendMessage(text, "91" + customer.mobileNumber)
              //     .then((value) => {
              //           if (value["status"] == "success")
              //             showSuccess("Message sent: " + text)
              //           else
              //             showError("Bill added but message not sent\n\"" +
              //                 value["errors"][0]["message"] +
              //                 "\"")
              //         }),

              // sender
              //     .sendSms(new SmsMessage(customer.mobileNumber, text))
              //     .then((message) => {
              //           showSuccess("Message sent: " + text),
              //         })
              //     .catchError((e) => {
              //           showError(e.message),
              //         }),

              _sendSMS(text, customer.mobileNumber)
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
