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
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  child: Image.network(
                      "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                ),
              ),
              Card(
                //margin: EdgeInsets.fromLTRB(0, 50, 0, 25),
                //alignment: Alignment.center,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(250, 50, 250, 10),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  title: Text("Username"),
                  //shape: ShapeBorder(),
                  trailing: Container(
                    width: 250,
                    child: TextFormField(
                      initialValue: "Username",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (text) {
                        username = text;
                      },
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(250, 10, 250, 50),
                child: ListTile(
                  leading: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),
                  title: Text("Password"),
                  trailing: Container(
                    width: 250,
                    child: TextFormField(
                      initialValue: "Password",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (text) {
                        password = text;
                      },
                    ),
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
