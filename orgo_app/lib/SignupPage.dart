import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //not sure kung pano ideal way nito sorry
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Icon _pwIcon(bool pwState) {
    if (pwState == true) {
      return Icon(
        Icons.visibility_off,
        color: Colors.grey,
      );
    } else {
      return Icon(
        Icons.visibility,
        color: Colors.grey,
      );
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
              margin: EdgeInsets.only(bottom: 60.0),
              child: Icon(
                Icons.donut_large,
                size: 100.0,
                color: Color.fromRGBO(0xFF, 0xC3, 0x0F, 1),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: TextFormField(
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: TextFormField(
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Username",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: TextFormField(
                        obscureText: _obscureText1,
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _toggle1();
                        },
                        child: _pwIcon(_obscureText1),
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: TextFormField(
                        obscureText: _obscureText2,
                        cursorColor: Colors.black,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _toggle2();
                        },
                        child: _pwIcon(_obscureText2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              height: 40.0,
              width: 120.0,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
