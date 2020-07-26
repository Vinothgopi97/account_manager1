import 'package:flutter/material.dart';

class NewBillPage extends StatefulWidget {
  @override
  _NewBillPageState createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Bill"),
        ),
        body: SafeArea(child: Container(
          alignment: Alignment.center,
          child: Center(
            child: Container(
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Form(
                            key: _key,
                            child:Container(
                              height: MediaQuery.of(context).size.height,
                              child:  ListView(
                                padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                                children: <Widget>[
//                                  NameInputField(_saveName),
//                                  Padding(padding: EdgeInsets.only(top: 10)),
//                                  MobileNumberInputField(_saveMobile),
//                                  Padding(padding: EdgeInsets.only(top: 10)),
//                                  AddressInputFiled(_saveAddress),
//                                  Padding(padding: EdgeInsets.only(top: 10)),
//                                  SignupButton(_key,_sendToNextScreen)
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                )
            ),
          ),
        ),)
    );
  }
}
