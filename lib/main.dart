import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel=AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,playSound: true
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=
FlutterLocalNotificationsPlugin();

Future<void> _firebaseBackMessaging(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("Backgroud ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackMessaging);
  await flutterLocalNotificationsPlugin.
  resolvePlatformSpecificImplementation
  <AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification=message.notification;
      AndroidNotification? androidNotification=message.notification?.android;
      if(notification!=null && androidNotification!=null)
        {
         flutterLocalNotificationsPlugin.show(
           notification.hashCode,
           notification.title,
           notification.body,
           NotificationDetails(
             android: AndroidNotificationDetails(
               channel.id,channel.name,
                 color: Colors.blue,
               playSound: true,
               icon:'@mipmap/ic_launcher'
             )
           )
         );
        }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification=message.notification;
      AndroidNotification? androidNotification=message.notification?.android;
      if(androidNotification!=null&& notification!=null)
        {
          showDialog(context: context, builder: (_){
            return AlertDialog(title: Text(notification.title.toString()),content:
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body.toString())],
                ),
              ),);
          });
        }
    });
  }
  Future<void> _incrementCounter() async {
    var data=
      {
        "entity": "event",
        "account_id": "acc_BFQ7uQEaa7j2z7",
        "event": "payment.captured",
        "contains": [
          "payment"
        ],
        "payload": {
          "payment": {
            "entity": {
              "id": "pay_DESlfW9H8K9uqM",
              "entity": "payment",
              "amount": 100,
              "currency": "INR",
              "base_amount": 100,
              "status": "captured",
              "order_id": "order_DESlLckIVRkHWj",
              "invoice_id": null,
              "international": false,
              "method": "netbanking",
              "amount_refunded": 0,
              "amount_transferred": 0,
              "refund_status": null,
              "captured": true,
              "description": null,
              "card_id": null,
              "bank": "HDFC",
              "wallet": null,
              "vpa": null,
              "email": "gaurav.kumar@example.com",
              "contact": "+919876543210",
              "notes": {
                "admnfee": "admd|1200",
                "tf":"jtoa|2300",
                "bf":"bus Fee|3400",
                "other":"insname|july to august--inwords|three "
                    "thousand--branch|1--rowid|436"
              },
              "fee": 2,
              "tax": 0,
              "error_code": null,
              "error_description": null,
              "error_source": null,
              "error_step": null,
              "error_reason": null,
              "acquirer_data": {
                "bank_transaction_id": "0125836177"
              },
              "created_at": 1567674599
            }
          }
        },
        "created_at": 1567674606
    };
    var url = Uri.parse(
        'http://117.247.90.209/app/kpshome/webhookaml.php');
    var response=await http.post(url,body: jsonEncode(data));
    if(response.statusCode==200)
    {
      print(response.body);
    }
  }
Future<void> getData()async{
  var data=
  {
    "entity": "event",
    "account_id": "acc_BFQ7uQEaa7j2z7",
    "event": "payment.captured",
    "contains": [
      "payment"
    ],
    "payload": {
      "payment": {
        "entity": {
          "id": "pay_DESlfW9H8K9uqM",
          "entity": "payment",
          "amount": 100,
          "currency": "INR",
          "base_amount": 100,
          "status": "captured",
          "order_id": "order_DESlLckIVRkHWj",
          "invoice_id": null,
          "international": false,
          "method": "netbanking",
          "amount_refunded": 0,
          "amount_transferred": 0,
          "refund_status": null,
          "captured": true,
          "description": null,
          "card_id": null,
          "bank": "HDFC",
          "wallet": null,
          "vpa": null,
          "email": "gaurav.kumar@example.com",
          "contact": "+919876543210",
          "notes": {
            "key1": "value1",
            "key2": "value2",
            "key3": "value3",
            "key4": "value4",
            "key5": "value5",
          },
          "fee": 2,
          "tax": 0,
          "error_code": null,
          "error_description": null,
          "error_source": null,
          "error_step": null,
          "error_reason": null,
          "acquirer_data": {
            "bank_transaction_id": "0125836177"
          },
          "created_at": 1567674599
        }
      }
    },
    "created_at": 1567674606
  };
  var url = Uri.parse(
      'http://117.247.90.209/app/kpshome/webhookaml.php');
  var response=await http.post(url,body: jsonEncode(data));
  if(response.statusCode==200)
  {
    print(response.body);
  }
}
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            MaterialButton(onPressed: (){},child: Text("Click here"),)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
