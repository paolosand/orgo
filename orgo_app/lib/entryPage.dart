import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
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
              margin: EdgeInsets.only(bottom: 60.0),
              child: Icon(
                Icons.donut_large,
                size: 100.0,
                color: Color.fromRGBO(0xFF, 0xC3, 0x0F, 1),
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
                  print("Login");
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
                  print("Signup");
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
