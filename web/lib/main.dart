import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_router/page_router.dart';

import 'entryPage.dart';
import 'signupPage.dart';
import 'loginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerData = PageRouterData({
    '/' : RoutePath(
      builder: (context, params) => FadeTransitionPage(
        key: ValueKey('/'),
        child: EntryPage(),
      )
    ),

    '/signup' : RoutePath(
      builder: (context, params) => FadeTransitionPage(
        key: ValueKey('/signup'),
        child: SignupPage(),
      )
    ),

    '/login' : RoutePath(
      builder: (context, params) => FadeTransitionPage(
        key: ValueKey('/login'),
        child: LoginPage(),
      )
    ),

  });



  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(_error) {
      print("ERROR!");
    }

    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting || !_initialized) {
          return MaterialApp(home: Splash());
        } else {
          print(_initialized);
          // Loading is done, return the app:
          return PageRouter(
            data: routerData,
            child: MaterialApp.router(
              title: 'Orgo',
              routerDelegate: routerData.routerDelegate,
              routeInformationParser: routerData.informationParser,
            ),
          );
        }
      },
    );
  }
}

class FadeTransitionPage extends Page {
  final Widget child;

  FadeTransitionPage({
    Key key,
    this.child,
  }) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff581845),
      body: Center(
        child:Icon(
          Icons.donut_large,
          color: Color(0xffFFBA33),
          size: MediaQuery.of(context).size.width * 0.785,
        ),
      ),
    );
  }
}