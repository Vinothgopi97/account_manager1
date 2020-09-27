import 'package:account_manager/modal/Bill.dart';
import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
// import 'package:sms/sms.dart';
// import 'package:sms_plugin/sms.dart';
// import 'package:sendsms/sendsms.dart';

class NewBillPage extends StatefulWidget {
  final Customer customer;

  final bool isAdmin;

  final Map<String, double> priceList;

  NewBillPage(this.customer, this.priceList, this.isAdmin);

  @override
  _NewBillPageState createState() =>
      _NewBillPageState(this.customer, this.priceList, this.isAdmin);
}

class _NewBillPageState extends State<NewBillPage> {
  Customer customer;
  Map<String, double> price;

  bool isAdmin;
  double total;
  List<String> liters;
  String selected;
  // SmsSender sender;
  String apiKey;
  _NewBillPageState(this.customer, this.price, this.isAdmin);

  GlobalKey<FormState> _key = GlobalKey();
  // final Telephony telephony = Telephony.instance;
  void _sendSMS(String message, String recipent) async {
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
    // sender.onSmsDelivered.listen((SmsMessage message) {
    //   print('${message.address} received your message.');
    // });
    // SmsMessage message1 = new SmsMessage(recipent, message);
    // sender
    //     .sendSms(message1, simCard: card.elementAt(0))
    //     .then((value) => {showSuccess("Message Sent: " + message)})
    //     .catchError((e) => {showError(e.toString())});
    // sender.sendSMS(message, simCard: card);

    // List<String> recipents = [recipent];
    // await sendSMS(message: message, recipients: recipents)
    //     .then((value) => {showSuccess("Message Sent: " + message)})
    //     .catchError((e) => {showError(e.toString())});
    // await Sendsms.onGetPermission();
    //
    // if (await Sendsms.hasPermission()) {
    //   await Sendsms.onSendSMS("91" + recipent, message)
    //       .then((value) => {
    //             showSuccess("Message Sent: " + message),
    //           })
    //       .catchError((e) => {showError(e.toString())});
    // }

    // bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    //
    // final SmsSendStatusListener listener = (SendStatus status) {
    //   if (SendStatus.SENT == status) {
    //     showSuccess("Message Sent");
    //   }
    //   if (SendStatus.DELIVERED == status) {
    //     showSuccess("Message Delivered");
    //   }
    // };
    // telephony.sendSms(to: recipent, message: message, statusListener: listener);
    // String _result =
    //     await sendSMS(message: message, recipients: recipents).catchError((e) {
    //   showError(e.message);
    // });
    // showSuccess("Message sent: " + message);
  }

  _callNumber(String number) async {
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  // MessageApi messageApi;

  @override
  void initState() {
    // sender = new SmsSender();
    // messageApi = MessageApi();

    total = 0;
    billIdKeyString = customer.customerId +
        "_" +
        DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString();
    // getTotalBill(billIdKeyString);
    getTotalBill(billIdKeyString).then((value) => {
          setState(() {
            total = value;
          })
        });
    liters = price.keys.toList();
    selected = liters.elementAt(0);
    super.initState();
  }

  String billIdKeyString;

  // getTotalBill(String billIdKeyString1) async {
  //   await FirebaseFirestore.instance
  //       .collection("bills")
  //       .where("billId", isEqualTo: billIdKeyString1)
  //       .snapshots()
  //       .listen((event) {
  //     double temp = 0.0;
  //     event.docs.forEach((element) {
  //       temp += element.get("billamount");
  //     });
  //
  //     setState(() {
  //       total = temp;
  //     });
  //   });
  // }

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

  var mobile;
  mobileSave(num) {
    print("in mobile save");
    print(num);
    mobile = num;
  }

  newMobileSave() async {
    if (_editNumKey.currentState.validate()) {
      _editNumKey.currentState.save();
      if (customer.mobileNumber == mobile) {
        Navigator.of(context).pop();
        showError("Existing and new mobile numbers are same.");
      } else {
        setState(() {
          customer.mobileNumber = mobile;
        });
        FirebaseFirestore.instance
            .collection("customers")
            .doc(customer.id)
            .update({"mobile": mobile})
            .then((value) => {
                  Navigator.of(context).pop(),
                  showSuccess("Mobile Number updated successfully"),
                })
            .catchError((e) => {
                  showError(e.toString()),
                });
      }
    }
  }

  GlobalKey<FormState> _editNumKey = GlobalKey();

  editMobile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.all(5),
        title: Align(
          alignment: Alignment.center,
          child: Text("Change Mobile Number"),
        ),
        content: Form(
            key: _editNumKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5)),
                Text("Name: " + customer.name),
                Padding(padding: EdgeInsets.all(5)),
                Text("Existing Mobile : " + customer.mobileNumber),
                Padding(padding: EdgeInsets.all(5)),
                MobileNumberInputField(mobileSave, null, null),
                Padding(padding: EdgeInsets.all(5)),
              ],
            )),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel")),
          FlatButton(onPressed: newMobileSave, child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "New Bill",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.phone),
                onPressed: () => {_callNumber(customer.mobileNumber)}),
            IconButton(
                icon: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: _viewMonthlyBill),
            IconButton(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                onPressed: _sendMMonthlyBill),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                  key: _key,
                  child: Container(
                      height: 290,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            Text(
                              customer.name,
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Row(
                                  children: [
                                    Text("Bill: "),
                                    Text(
                                      "₹ " + total.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text("Id: "),
                                    Text(
                                      customer.customerId,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),

                            // Padding(padding: EdgeInsets.only(top: 10)),
                            //
                            // Padding(padding: EdgeInsets.only(top: 10)),
                            isAdmin
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Mobile: " + customer.mobileNumber),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: editMobile)
                                    ],
                                  )
                                : Text("Mobile: " + customer.mobileNumber),
                            Spacer(),
                            Text("Delivery person: " +
                                customer.deliveryPersonName),
                            Spacer(),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Liters delivered"),
                                  DropdownButton<String>(
                                    items: liters
                                        .map<DropdownMenuItem<String>>((e) {
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
                            ),
                            RaisedButton(
                                child: Text(
                                  "Add Bill",
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: addBill),
                            Spacer(),
                          ],
                        ),
                      ))),
              Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Text("Liters"),
                    title: Text("Date"),
                    trailing: Text("Amount"),
                  ),
                  Container(
                    height: 300,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("bills")
                            .where("billId", isEqualTo: billIdKeyString)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Text("Loading...");
                          else
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  Bill bill = Bill.fromQueryDocumentSnapshot(
                                      snapshot.data.documents[index]);

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.lightBlueAccent,
                                      child: Text(
                                        bill.litersDelivered.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      bill.billDate,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    trailing:
                                        Text("₹ " + bill.price.toString()),
                                  );
                                });
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  showError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
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
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  int oldid = 0;
  addBill() async {
    double oldTotal = total;
    total = 0;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    Bill bill = Bill(customer.customerId, customer.name, double.parse(selected),
        price[selected], date);
    List<String> mobiles = new List<String>();
    mobiles.add(customer.mobileNumber);
    String text = "Milk bill on " +
        date +
        "\nExisting:₹" +
        oldTotal.toString() +
        "\nNew:₹" +
        price[selected].toString() +
        "\nTotal: ₹" +
        (oldTotal + price[selected]).toString();
    setState(() {
      total = oldTotal + price[selected];
    });

    await FirebaseFirestore.instance
        .collection("config")
        .doc("bill")
        .get()
        .then((value) => {oldid = value.get("nextId")});
    FirebaseFirestore.instance
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

  _viewMonthlyBill() {
    double total1 = total;
    String month = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    String text =
        "Total milk bill for the month " + month + " is ₹ " + total1.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Customer: " + customer.name),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    customer = null;
    price = null;
    total = null;
    super.dispose();
  }

  _sendMMonthlyBill() {
    double total1 = total;
    String month = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    String text =
        "Total milk bill for the month " + month + " is ₹ " + total1.toString();
    List<String> mobiles = new List<String>();
    mobiles.add(customer.mobileNumber);
    _sendSMS(text, customer.mobileNumber);
    // messageApi
    //     .sendMessage(text, "91" + customer.mobileNumber)
    //     .then((value) => {
    //           if (value["status"] == "success")
    //             showSuccess("Monthly bill sent, Message: " + text)
    //           else
    //             {print(value), showError(value["errors"][0]["message"])}
    //         })
    //     .catchError((e) => {
    //           showError(e.message),
    //         });
    // sender
    //     .sendSms(new SmsMessage(customer.mobileNumber, text))
    //     .then((message) => {
    //           showSuccess("Monthly bill sent, Message: " + text),
    //         })
    //     .catchError((e) => {
    //           showError(e.message),
    //         });
  }
}
