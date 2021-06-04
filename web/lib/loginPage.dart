import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_router/page_router.dart';

const Color kCardContentColor = Color(0xffC70039);

enum CardName {
  email,
  password,
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  bool _obscureText = true;

  CardName selectedCard = CardName.email;

  @override
  void initState() {
    super.initState();
    auth.setPersistence(Persistence.LOCAL);
  }

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

  void login(String email, String password) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Logging in')));

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Success!')));
      await new Future.delayed(const Duration(seconds: 5));
      Navigator.pop(
          context); // use this command for now to provide a visual change
      PageRouter.of(context).pushNamed(
          '/mainpage'); //add this code to route to the main page with all the profiles

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wrong password provided for that user.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xff581845),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(bottom: 60.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  // child: Image.network(
                  //     "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                  child: Icon(
                    Icons.donut_large,
                    color: Color(0xffFFBA33),
                  ),
                ),
              ),
              Card(
                //margin: EdgeInsets.fromLTRB(0, 50, 0, 25),
                //alignment: Alignment.center,
                // elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
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
                      _email = value;
                      return null;
                    },
                    onChanged: (text) {
                      _email = text;
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
                margin: EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
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
                    obscureText: _obscureText,
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
                      _password = value;
                      return null;
                    },
                    onChanged: (text) {
                      _password = text;
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
                        _obscureText = !_obscureText;
                      });
                    },
                    tooltip: "Show/Hide Password",
                    icon: _obscureText
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
              SizedBox(height: 50.0),
              Container(
                height: 40.0,
                width: 120.0,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0xC7, 0x00, 0x39, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () => login(_email, _password),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
