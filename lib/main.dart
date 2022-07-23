import 'package:fairywala/pages/Homepage.dart';
import 'package:fairywala/pages/auth_screen.dart';
import 'package:fairywala/pages/schedule_request.dart';
import 'package:fairywala/pages/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            // return NgoDonationsRequests();

            return const HomeScreen();
          }
//hi
          return const AuthScreen();
        },
      ),
      routes: {
        '/hello': (context) => const ScheduleRequest(),
        '/userInfo': (context) => UserSubmitInfo(),
      },
      // home: HomeScreen(),
    );
  }
}
