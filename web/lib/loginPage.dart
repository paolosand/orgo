import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";
  bool _obscureText = true;

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
                    icon: Icon(Icons.person),
                    labelText: 'Username',
                  ),
                  onChanged: (text) {
                    _username = text;
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
              GestureDetector(
                onTap: () => _LoginPageState(),
                child: Card(
                  color: Color(0xffC70039),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: Text(
                    "       \n     LOG IN     \n       ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
