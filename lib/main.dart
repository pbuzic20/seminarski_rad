import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seminarski_rad/Lokal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seminarski_rad/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seminarski rad',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Seminarski rad'),
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
  final player = AudioPlayer();

  void initState(){
    super.initState();
    Lokal.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
                player.play(AssetSource('music.mp3'));
                Lokal.showBigTextNotification(title: "Upozorenje", body: "Pustio si glazbu", fln: flutterLocalNotificationsPlugin);
                },
                child: const Text('Pusti glazbu'),
            ),
            ElevatedButton(onPressed: (){
              player.stop();
              Lokal.showBigTextNotification(title: "Upozorenje", body: "Prekinuo si glazbu", fln: flutterLocalNotificationsPlugin);
            }, child: const Text('Prekini glazbu')),

            ElevatedButton(onPressed: () {
              player.pause();
              Lokal.showBigTextNotification(title: "Upozorenje", body: "Pauzirao si glazbu", fln: flutterLocalNotificationsPlugin);
            }, child: const Text('Pauziraj')),

            ElevatedButton(onPressed: (){
              player.resume();
              Lokal.showBigTextNotification(title: "Upozorenje", body: "Nastavio si glazbu", fln: flutterLocalNotificationsPlugin);
            }, child: const Text('Nastavi')),
          ],
        ),
      ),
    );
  }
}
