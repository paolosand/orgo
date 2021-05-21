import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color kCardContentColor = Color(0xffC70039);

enum CardName {
  email,
  password,
  confirmPassword,
}

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

  CardName selectedCard = CardName.email;

  ShapeBorder getBorder(CardName cardName) {
    return selectedCard == cardName
        ? RoundedRectangleBorder(
            side: BorderSide(
              color: kCardContentColor,
              width: 2.0,
            ),
          )
        : RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          );
  }

  void signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Success!')));
      CollectionReference users =
          FirebaseFirestore.instance.collection(auth.currentUser.uid);
      print(auth.currentUser.uid);
      Future<void> addUser() {
        // Call the user's CollectionReference to add a new user
        users
            .doc('notifications')
            .set({'data': [], 'data_count': 0, 'title_list': []})
            .then((value) => print("User Notification data Added"))
            .catchError((error) =>
                print("Failed to add user notification data: $error"));

        users
            .doc('data')
            .set({'isParent': false})
            .then((value) => print("User isParent field Added"))
            .catchError((error) => print("$error"));

        return users
            .doc('profiles')
            .set({'profile_count': 0, 'profile_names': []})
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }

      addUser();

      await new Future.delayed(const Duration(seconds: 5));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
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
                    shape: getBorder(CardName.email),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: selectedCard == CardName.email
                            ? kCardContentColor
                            : Colors.grey,
                      ),
                      selected: selectedCard == CardName.email,
                      title: TextFormField(
                        autofocus: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          email = value;
                          return null;
                        },
                        onChanged: (text) {
                          email = text;
                        },
                        onTap: () {
                          setState(() {
                            selectedCard = CardName.email;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    shape: getBorder(CardName.password),
                    child: ListTile(
                      leading: Icon(
                        Icons.lock,
                        color: selectedCard == CardName.password
                            ? kCardContentColor
                            : Colors.grey,
                      ),
                      selected: selectedCard == CardName.password,
                      title: TextFormField(
                        obscureText: _obscureText1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          password = value;
                          return null;
                        },
                        onChanged: (text) {
                          password = text;
                        },
                        onTap: () {
                          setState(() {
                            selectedCard = CardName.password;
                          });
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                        tooltip: "Show/Hide Password",
                        icon: _obscureText1
                            ? Icon(
                                Icons.visibility_off,
                                color: selectedCard == CardName.password
                                    ? kCardContentColor
                                    : Colors.grey,
                              )
                            : Icon(
                                Icons.visibility,
                                color: selectedCard == CardName.password
                                    ? kCardContentColor
                                    : Colors.grey,
                              ),
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                    shape: getBorder(CardName.confirmPassword),
                    child: ListTile(
                      leading: Icon(Icons.lock,
                          color: selectedCard == CardName.confirmPassword
                              ? kCardContentColor
                              : Colors.grey),
                      selected: selectedCard == CardName.confirmPassword,
                      title: TextFormField(
                        obscureText: _obscureText2,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          confirmpass = value;
                          return null;
                        },
                        onTap: () {
                          setState(() {
                            selectedCard = CardName.confirmPassword;
                          });
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        tooltip: "Show/Hide Password",
                        icon: _obscureText2
                            ? Icon(Icons.visibility_off,
                                color: selectedCard == CardName.confirmPassword
                                    ? kCardContentColor
                                    : Colors.grey)
                            : Icon(Icons.visibility,
                                color: selectedCard == CardName.confirmPassword
                                    ? kCardContentColor
                                    : Colors.grey),
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
                  if (_formKey.currentState.validate() &&
                      (password == confirmpass)) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Signing Up')));
                    signup(email, password);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Passwords do not match')));
                  }
                },
                child: Text(
                  'SIGN UP',
                  style: TextStyle(color: Color(0xffC70039), fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
