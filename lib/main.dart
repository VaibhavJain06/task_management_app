import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/Auth/auth_screen.dart';
import 'package:task_management_app/Auth/bloc/auth_bloc.dart';   
import 'package:task_management_app/Home/Home.dart';     
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home/bloc/home_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
          if (snapshot.hasData) {
            return const Home();
          }
          return AuthScreen();
        },
      )
    ),
    );
  }
}

