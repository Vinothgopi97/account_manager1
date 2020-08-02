import 'package:account_manager/modal/Bill.dart';
import 'package:account_manager/modal/Customer.dart';
import 'package:account_manager/views/components/MobileNumberInputField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
//import 'package:flutter_sms/flutter_sms.dart';

class NewBillPage extends StatefulWidget {

  Customer customer;

  bool isAdmin;

  Map<String,double> priceList;

  NewBillPage(this.customer,this.priceList,this.isAdmin);

  @override
  _NewBillPageState createState() => _NewBillPageState(this.customer,this.priceList,this.isAdmin);
}

class _NewBillPageState extends State<NewBillPage> {

//  String customerId;
//  String customerName;
//  String mobile;
  Customer customer;
  Map<String,double> price;

  bool isAdmin;

  List<String> liters;
  String selected;
  SmsSender sender;
//  String mobile = "+918760603355";
  _NewBillPageState(this.customer,this.price,this.isAdmin);

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("bill");
  DatabaseReference _customerDatabaseRef = FirebaseDatabase.instance.reference().child("customer");

  GlobalKey<FormState> _key = GlobalKey();


  @override
  void initState() {

    sender = new SmsSender();
 total = 0;
 billIdKeyString = customer.customerId+"_"+DateTime.now().year.toString()+"-"+DateTime.now().month.toString();
 print(price);
    liters = price.keys.toList();
    selected = liters.elementAt(0);
//    getTotal();
    super.initState();
  }

  double total;
  String billIdKeyString;

  getTotal() async{
    total = 0;
    double val = 0;
    await _databaseReference.orderByChild("customerId").equalTo(customer.customerId).onValue.listen((event) {

//      val = val + double.parse(event.snapshot.value["billamount"]);
    }).onDone(() {
      setState(() {
        total = val;
      });
    });
  }

  var mobile;
  mobileSave(num){
    print("in mobile save");
    print(num);
    mobile = num;
  }

  newMobileSave() async{
    if(_editNumKey.currentState.validate()){
      _editNumKey.currentState.save();
      if(customer.mobileNumber == mobile){
        Navigator.of(context).pop();
        showError("Existing and new mobile numbers are same.");
      }
      else{
        setState(() {
          customer.mobileNumber = mobile;
        });
        print(customer.id);
        print(customer.toJson());
        await _customerDatabaseRef.child(customer.id).update(customer.toJson()).then((value) => {
          Navigator.of(context).pop(),
          showSuccess("Mobile Number updated successfully"),
        });
      }
    }
  }

  GlobalKey<FormState> _editNumKey = GlobalKey();

  editMobile() async{
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Change Mobile Number"),
        content: Form(
          key: _editNumKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Name: "+customer.name),
            Text("Existing Mobile : "+customer.mobileNumber),
            MobileNumberInputField(mobileSave, null, null),
          ],
        )),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Cancel")),
          FlatButton(onPressed: newMobileSave, child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    total=0;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("New Bill",style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.info,color: Colors.white,), onPressed: _viewMonthlyBill),
            IconButton(icon: Icon(Icons.message,color: Colors.white,), onPressed: _sendMMonthlyBill),
          ],
        ),
        body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                  key: _key,
                  child:Container(
                      height: 300,
                      child: Card(
                        child:  Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text("Customer Id: "+customer.customerId),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            isAdmin ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Mobile: "+ customer.mobileNumber),
                                IconButton(icon: Icon(Icons.edit), onPressed: editMobile)
                              ],
                            ) : Text("Mobile: "+ customer.mobileNumber),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text("Customer Name: "+ customer.name),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text("Deelivery person: "+ customer.deliveryPersonName),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Lliters delivered"),
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
                                ],
                              ),),
                            RaisedButton(
                                child: Text("Add Bill",style: Theme.of(context).textTheme.button,),
                                onPressed: addBill),

                          ],
                        ),
                      )
                  )
              ),
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
                    child: FirebaseAnimatedList(

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      defaultChild: Center(child: CircularProgressIndicator(),),
                      query: _databaseReference.orderByChild("billId").equalTo(billIdKeyString),
                      itemBuilder: (context,snapshot,animation,index){
                        Bill bill = Bill.fromSnapshot(snapshot);
                        total = total + double.parse(bill.price.toString());
                        print(total);
                        return ListTile(
                          dense: true,
                          leading: Text(bill.litersDelivered.toString()),
                          title: Text(bill.billDate),
                          trailing: Text("₹ "+bill.price.toString()),
                        );
                      },

                    ),
                  ),
                ],
              ),
            ],
          ),
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
    String month = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    Bill bill = Bill(customer.customerId, customer.name, double.parse(selected), price[selected] , date);
    String text = "Milk bill\nExisting:₹"+ oldTotal.toString()+"\nNew:₹"+price[selected].toString()+".\nTotal: ₹"+ (oldTotal+price[selected]).toString();
    await _databaseReference.push().set(bill.toJson()).whenComplete(()async => {
      sender.sendSms(new SmsMessage(customer.mobileNumber, text)),
//      await sendSMS(message: text, recipients: ["+918760603355"]),
      showSuccess(text),
      _key.currentState.reset(),
    }).catchError((err)=>{
      showError(err.message)
    });
  }

  _viewMonthlyBill(){
    double total1 = total;
    String month = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    String text = "Total milk bill for the month "+month+" is ₹ "+total1.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Customer: "+customer.name),
        content: Text(text),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("OK"))
        ],
      ),
    );
  }

  _sendMMonthlyBill(){
    double total1 = total;
    String month = DateFormat('yyyy-MM').format(DateTime.now()).toString();
    String text = "Total milk bill for the month "+month+" is ₹ "+total1.toString();
    sender.sendSms(new SmsMessage(customer.mobileNumber, text)).then((message) => {
      showSuccess("Monthly bill sent, Message: "+text),
    }).catchError((e)=>{
      showError(e.message),
    });
  }
}
