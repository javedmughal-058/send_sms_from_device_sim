import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Send SMS Using Device Sim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Send SMS Using Device Sim'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: toController,
                decoration: const InputDecoration(labelText: 'To'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendSMS,
        tooltip: 'Send Msg',
        child: const Icon(Icons.send_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void sendSMS() async {
    var numberList = [];
    if(toController.text.toString() == ""){
     numberList = ["03024716341","03027566364"];
    }
    else{
      if(toController.text.toString().contains(",")){
        List<String> recipients = toController.text.toString().split(',').map((e) => e.trim()).toList();
        numberList.addAll(recipients);
      }
      else{
        numberList.add(toController.text.trim().toString());
      }
    }

    final status = await Permission.sms.request();
    if (status.isGranted) {
      bool? result = await BackgroundSms.isSupportCustomSim;
      debugPrint("Result $result");
      if (result!) {
        debugPrint("Support Custom Sim Slot");
        for(int i=1; i<=numberList.length; i++){
          SmsStatus result = await BackgroundSms.sendMessage(
              phoneNumber: numberList[i-1], message: messageController.text.toString() == ""
              ? "Hello, Flutter Developer. It is testing message from device sim"
              : messageController.text.toString());
          if (result == SmsStatus.sent) {
            debugPrint("${messageController.text.toString() == ""
                ? "Hello, Flutter Developer. It is testing message from device sim"
                : messageController.text.toString()} Sent to ${numberList[i-1]}");
            if(i == numberList.length){
              toController.clear();
              messageController.clear();
            }

          }
          else {
            debugPrint("Failed");
          }
        }
      }
      else {
        debugPrint("Not Support Custom Sim Slot");
        for(int i=1; i<=numberList.length; i++){
          SmsStatus result = await BackgroundSms.sendMessage(
              phoneNumber: numberList[i-1], message: messageController.text.toString() == ""
              ? "Hello, Flutter Developer. It is testing message from device sim"
              : messageController.text.toString());
          if (result == SmsStatus.sent) {
            debugPrint("${messageController.text.toString() == ""
                ? "Hello, Flutter Developer. It is testing message from device sim"
                : messageController.text.toString()} Sent to ${numberList[i-1]}");
            if(i == numberList.length){
              toController.clear();
              messageController.clear();
            }

          }
          else {
            debugPrint("Failed");
          }
        }
      }
    }
    else {
      debugPrint("Have not permission to send msg");
    }
  }
}
