import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_router/page_router.dart';

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

  void login(String email, String password) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in')));

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success!')));
      await new Future.delayed(const Duration(seconds : 5));
      Navigator.pop(context); // use this command for now to provide a visual change
      // PageRouter.of(context).pushNamed('/mainpage'); add this code to route to the main page with all the profiles

      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password provided for that user.')));
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
                width: 75,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                margin: EdgeInsets.fromLTRB(50, 50, 50, 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  onChanged: (text) {
                    _email = text;
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                child: TextFormField(
                  //initialValue: "Password",
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                  onChanged: (text) {
                    _password = text;
                  },
                  obscureText: _obscureText,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                color: Color(0xffC70039),
                tooltip: 'Show/Hide Password',
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              Container(
              height: 40.0,
              width: 120.0,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () => login(_email, _password),
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
      ),
    );
  }
}
