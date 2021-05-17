import 'package:flutter/material.dart';
import 'package:page_router/page_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentEntryPage extends StatefulWidget {
  ParentEntryPage({Key key}) : super(key: key);

  @override
  _ParentEntryPageState createState() => _ParentEntryPageState();
}

class _ParentEntryPageState extends State<ParentEntryPage> {
  FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    auth.setPersistence(Persistence.LOCAL);
    getLandingPage(auth);
  }

  Future<void> getLandingPage(FirebaseAuth auth) async {
    if (auth.currentUser != null) {
      PageRouter.of(context).pushNamed('/mainpage');
      print(auth.currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0x58, 0x18, 0x45, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Icon(
                Icons.donut_large,
                size: 100.0,
                color: Color.fromRGBO(0xFF, 0xC3, 0x0F, 1),
              ),
            ),
            Container(
              height: 40,
              width: 200,
              // margin: EdgeInsets.only(bottom: 60.0),
              child: Text(
                "Orgo for Parents",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 40.0,
              width: 150.0,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0xC7, 0x00, 0x39, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  print("Parent Login");
                  PageRouter.of(context).pushNamed('/parentLogin');
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 40.0,
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  print("Parent Signup");
                  PageRouter.of(context).pushNamed('/parentSignup');
                },
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      color: Color.fromRGBO(0xC7, 0x00, 0x39, 1),
                      fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
