import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//Telas
import 'Telas/TelaLogin.dart';
import 'package:desafio_mobile/Telas/TelaDashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/TelaLogin": (context) => TelaLogin(),
        "/TelaDashboard": (context) => TelaDashboard()
      },
      title: 'App Desafio Mobile',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'GothamMedium'),
      home: new TelaLogin(),
    );
  }
}
