import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MessageApi {
  String apiKey;

  MessageApi() {
    FirebaseFirestore.instance
        .collection("config")
        .doc("smsapi")
        .get()
        .then((value) => {
              apiKey = value.get("key"),
              print("API KEY" + apiKey),
            });
  }

  Future<Map<String, dynamic>> sendMessage(content, numbers) async {
    String url = "https://api.textlocal.in/send/?sender=TXTLCL";
    url = url + "&message=" + Uri.encodeComponent(content);
    url = url + "&numbers=" + numbers;
    url = url + "&apiKey=" + apiKey;
    url = url + "&unicode=" + "true";
    // url = url + "&test=" + "true";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> m = json.decode(response.body);
      return m;
    } else {
      throw Exception('Failed to send sms');
    }
  }
}
