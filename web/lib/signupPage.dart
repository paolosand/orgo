import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;


  //not sure kung pano ideal way nito sorry
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String email = "";
  String password = "";
  String confirmpass = "";

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

  void signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success!')));
      CollectionReference users = FirebaseFirestore.instance.collection(auth.currentUser.uid);
      print(auth.currentUser.uid);
      Future<void> addUser() {
        // Call the user's CollectionReference to add a new user
        users
        .doc('notifcations')
        .set({
          'data' : [],
          'data_count' : 0,
          'title_list' : []
        })
        .then((value) => print("User Notification data Added"))
        .catchError((error) => print("Failed to add user notification data: $error"));

        return users
          .doc('profiles')
          .set({
            'profile_count' : 0,
            'profile_names' : []
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      }

      addUser();

      await new Future.delayed(const Duration(seconds : 5));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      print(e);
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
                          email = value;
                          return null;
                        },
                        onChanged: (text){
                          email = text;
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
                          password = value;
                          return null;
                        },
                        onChanged: (text){
                          password = text;
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
                          confirmpass = value;
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
                  if (_formKey.currentState.validate() && (password == confirmpass)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signing Up')));
                    signup(email, password);
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                  }
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
