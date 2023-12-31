import 'package:activity_tracker/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options:FirebaseOptions(
     apiKey: 'AIzaSyCFZ-_GpRvZdkAcm6vmT4h8-m5exZkPCdk',
    appId: '1:395011371299:web:1d4f4cf559f0110a9b5c96',
    messagingSenderId: '395011371299',
    projectId: 'activitytracker-d9e36',
    authDomain: 'activitytracker-d9e36.firebaseapp.com',
    storageBucket: 'activitytracker-d9e36.appspot.com',
    measurementId: 'G-J94QF7Z1YK',
  ));
  
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      
       debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}


