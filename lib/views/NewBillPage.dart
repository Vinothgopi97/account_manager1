import 'package:account_manager/modal/Bill.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
//import 'package:flutter_sms/flutter_sms.dart';

class NewBillPage extends StatefulWidget {

  String customerId;
  String customerName;

  NewBillPage(this.customerId, this.customerName);

  @override
  _NewBillPageState createState() => _NewBillPageState(this.customerId, this.customerName);
}

class _NewBillPageState extends State<NewBillPage> {

  String customerId;
  String customerName;

  Map<String,double> price = {"0.5":20,"1":35};
  List<String> liters;
  String selected;
  SmsSender sender;
  String mobile = "+918760603355";
  _NewBillPageState(this.customerId, this.customerName);

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("bill");

  GlobalKey<FormState> _key = GlobalKey();


  @override
  void initState() {
    liters = price.keys.toList();
    selected = liters.elementAt(0);
    sender = new SmsSender();
 total = 0;
 billIdKeyString = customerId+"_"+DateTime.now().year.toString()+"-"+DateTime.now().month.toString();
 print(billIdKeyString);
//    getTotal();
    super.initState();
  }

  double total;
  String billIdKeyString;

  getTotal() async{
    total = 0;
    double val = 0;
    await _databaseReference.orderByChild("customerId").equalTo(customerId).onValue.listen((event) {

//      val = val + double.parse(event.snapshot.value["billamount"]);
    }).onDone(() {
      setState(() {
        total = val;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Bill"),
        ),
        body:Column(
          children: <Widget>[
            Form(
                key: _key,
                child:Container(
                  height: 200,
                  child:  ListView(
                    padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                    children: <Widget>[
                      Text("Customer Id: "+customerId.toString()),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text("Customer Name: "+ customerName),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      DropdownButton<String>(
                        items: liters.map<DropdownMenuItem<String>>((e){
                          return DropdownMenuItem<String>(
                              value: e.toString(),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  Text(e.toString()),
                                ],
                              ));
                        }).toList(),
                        onChanged: (e){
                          setState(() {
                            selected= e.toString();
                          });
                        },
                        value: selected,

                      ),
                      RaisedButton(
                          child: Text("Add Bill"),
                          onPressed: addBill),

                    ],
                  ),
                )
            ),
            Container(
              height: 300,
              child: FirebaseAnimatedList(

                shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  defaultChild: CircularProgressIndicator(),
                  query: _databaseReference.orderByChild("billId").equalTo(billIdKeyString),
                  itemBuilder: (context,snapshot,animation,index){
                    Bill bill = Bill.fromSnapshot(snapshot);
                      total = total + double.parse(bill.price.toString());
                      print(total);
                    return ListTile(
                      leading: Text(bill.litersDelivered.toString()),
                      title: Text(bill.billDate),
                      trailing: Text(bill.price.toString()),
                    );
                  },

              ),
            ),
          ],
        )

    );
  }

  showError(String error){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  showSuccess(String text){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Success"),
        content: Text(text),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  addBill() async{
    double oldTotal = total;
    total = 0;
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    Bill bill = Bill(customerId, customerName, double.parse(selected), price[selected] , date);
    String text = "Existing bill: ₹"+ oldTotal.toString()+", current bill: ₹"+price[selected].toString()+"\n Total bill: ₹"+ (oldTotal+price[selected]).toString();
    await _databaseReference.push().set(bill.toJson()).whenComplete(()async => {
      sender.sendSms(new SmsMessage(mobile, text)),
//      await sendSMS(message: text, recipients: ["+918760603355"]),
      showSuccess(text),
      _key.currentState.reset(),
    }).catchError((err)=>{
      showError(err.message)
    });
  }
}
