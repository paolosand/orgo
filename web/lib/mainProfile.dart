import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// delete or change all the placeholders. just made this file to see how the popups should work.

// PLaceholder lang. Used to fill up the placeholder account grid.
final List<String> classes = [
  'CS 1',
  'CS 2',
  'CS 3',
  'CS 4',
  'CS 5',
  'CS 6',
  'CS 7',
  'CS 8',
  'CS 9',
  'CS 10',
  'CS 11',
  'CS 12',
  'CS 13',
  'CS 14',
  'CS 15',
  'CS 16',
  'CS 17',
  'CS 18',
  'CS 19',
  'CS 20',
];

// Placeholder lang din. Used to create the placeholder content for the profile pull up widget.
List<String> profiles = [
  'school',
  'internship',
  'scholar',
  'school',
  'internship',
  'scholar',
  'school',
  'internship',
  'scholar'
];

// A constant body textstyle used in the view account popup
const TextStyle kViewBody =
    TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w700);

class MainProfile extends StatefulWidget {
  const MainProfile({Key key}) : super(key: key);
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool panelVisible =
      false; // to hide the contents of the panel when collapsed.
  // function to call when the user wants to add an account.
  Future<void> addAccountPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(
              'Add Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputAccountCard(
                        hintText: "Account Name",
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),
                      InputAccountCard(
                        hintText: "Email",
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),
                      InputAccountCard(
                        hintText: "Password",
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),
                      InputAccountCard(
                        hintText: "Site URL",
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 30,
                        width: 90,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff581845)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xff581845)),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  // function to call when the user wants to view the content of an account (class).
  // add input na lang from the back end para mapalitan yung username, pw, url, title, pic?
  // Change to appropriate data types based sa kukunin natin from users?
  Future<void> viewAccountPopup(String accountTitle, String username,
      String password, String websiteURL, String imageURL) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Color(0xffffc30f),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.settings, color: Colors.white),
                Text(
                  accountTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 25.0)
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                height: 350,
                width: 250,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageURL),
                      backgroundColor: Colors.white,
                      radius: 80.0,
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      username,
                      style: kViewBody,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      password,
                      style: kViewBody,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      websiteURL,
                      style: kViewBody,
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      margin: EdgeInsets.only(top: 25.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Visit Link',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // just used to mess with the placeholder background.
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Color(0xff581845),
      body: SlidingUpPanel(
        onPanelSlide: (double size) {
          // hide panel content until partially opened.
          setState(() {
            if (size < 0.3) {
              panelVisible = false;
            } else {
              panelVisible = true;
            }
          });
        },
        // content of the panel
        panelBuilder: (ScrollController sc) {
          return Visibility(
            visible: panelVisible,
            child: Container(
              child: Column(
                children: [
                  // kinda like the header
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              color: Color(0xff581845),
                              size: 30.0,
                            ),
                          ),
                        ),
                        Text(
                          'Profiles',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 75.0,
                        )
                      ],
                    ),
                  ),
                  // the scrollable view of profiles
                  Expanded(
                    flex: 6,
                    child: Scrollbar(
                      child: ListView.separated(
                        controller: sc,
                        padding: const EdgeInsets.all(8),
                        itemCount: profiles.length,
                        // to display all the profiles. add the backend stuff here to replace the placeholder profiles list??
                        itemBuilder: (BuildContext context, int index) {
                          String item = profiles[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.height / 8),
                            height: 50.0,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff43aa8b)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Color(0xff43aa8b)),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 40.0),
                                  Text(
                                    item,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.double_arrow_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 20.0),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          color: Color(0xff581845),
                          size: 32.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        collapsed: Center(
          child: Icon(Icons.keyboard_arrow_up),
        ),
        minHeight: 70.0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        backdropEnabled: true,
        // the placeholder background that displays accounts (classes)
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: classes
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffffc30f),
                            ),
                            child: TextButton(
                              onPressed: () {
                                viewAccountPopup(
                                    'CS 194',
                                    'username',
                                    'password',
                                    'website URL',
                                    'https://i.insider.com/5abb9eb43216742a008b45cc?width=1200&format=jpeg');
                              },
                              child: Center(
                                child: Text(
                                  item,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // part of the placeholder which the user clicks to add an account
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      addAccountPopup();
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // added so the main content will not be blocked by the pull up widget.
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A custom widget used in the add account popup. Just adds styling to avoid repetition.
class InputAccountCard extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChanged;
  InputAccountCard({this.hintText, this.validator, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 200,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)),
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText,
            hintStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[300]),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
