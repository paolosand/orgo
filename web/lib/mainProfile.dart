import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:schedulers/schedulers.dart';
import 'package:date_field/date_field.dart';

// A constant body textstyle used in the view account popup
const TextStyle kViewBody = TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w700);

// A constant heading textstyle for the popups (except view) and pull up widget.
const TextStyle kHeading = TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0);

// A constant textstyle used for most button labels.
const TextStyle kButtonLabel = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);


class MainProfile extends StatefulWidget {
  const MainProfile({Key key}) : super(key: key);
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PanelController panelController = PanelController();
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> accounts = [];
  Map<String, dynamic> accData = {};
  Map<String,dynamic> editaccData = {};
  String currentProfile = "";
  int currentClassColor = 0;

  List<MaterialColor> colorList = Colors.primaries;
  int currentColorIndex = 0;

  double panelOpacity = 0.0; // to change panel opacity based on how much the panel is opened

  // function to call for encrypting plaintext password into cipher text (for saving in database)
  en.Encrypted encryptPass(String password) {
    var key = en.Key.fromUtf8("cs192orgo.......................");
    var iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));

    final encrypted = encrypter.encrypt(password, iv: iv);
    print("successful encryption");
    return encrypted;
  }

  //function to call to decrypt queried ciphertext password so that it can be shown in app
  String decryptPass(String password) {
    var key = en.Key.fromUtf8("cs192orgo.......................");
    var iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));

    final decrypted = encrypter.decrypt64(password, iv: iv);
    print("Resulting Decrypted Password: " + decrypted);
    return decrypted;
  }

  //function to call to show the user the add account dialog entry
  Future<void> addAccountPopup() async {
    String addAccName, addEmail, addPass, addURL;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Add Account',
            style: kHeading,
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
                        } else if (accounts.contains(value)) {
                          return 'Account already exists';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        addAccName = text;
                      },
                    ),
                    InputAccountCard(
                      hintText: "Email",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        addEmail = text;
                      },
                    ),
                    InputAccountCard(
                      hintText: "Password",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        addPass = text;
                      },
                    ),
                    InputAccountCard(
                      hintText: "Site URL",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        addURL = text;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff581845)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xff581845)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            
                            addAccount(currentProfile, addAccName, addEmail,
                                addPass, addURL);
                            getClassList(currentProfile);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Account data being added')));
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Account data successfully added')));
                          }
                        },
                        child: Text(
                          'Add',
                          style: kButtonLabel,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // function to call when the user wants to edit the content of an account (class).
  Future<void> editAccountPopup(String accName, accEmail, accPass, accURL) async {
    String editEmail, editPass, editURL;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(
              'Add Account',
              style: kHeading,
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
                        hintText: accEmail,
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          editEmail = text;
                        },
                      ),
                      InputAccountCard(
                        hintText: accPass,
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          editPass = text;
                        },
                      ),
                      InputAccountCard(
                        hintText: accURL,
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          editURL = text;
                        },
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Account data successfully changed')));
                              editAccount(currentProfile, accName, editEmail,
                                  editPass, editURL);
                              getClassList(currentProfile);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Save',
                            style: kButtonLabel,
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
  Future<void> viewAccountPopup(String accountTitle, String email, String password, String websiteURL, String imageURL) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: colorList[currentClassColor],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  editAccountPopup(accountTitle, email, password, websiteURL);
                },
              ),
              Text(
                accountTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  deleteAccount(currentProfile, accountTitle);
                  getClassList(currentProfile);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account successfully removed')));
                },
              ),
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
                    email,
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
                      onPressed: () async {
                        if (await canLaunch(websiteURL)) {
                          await launch(websiteURL,
                              forceSafariVC: true, forceWebView: true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Website could not be reached')));
                          throw 'Could not launch $websiteURL';
                        }
                      },
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
      },
    );
  }

  // function to call when the user wants to add a new profile.
  Future<void> addProfilePopup() async {
    String profileName = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Add Profile',
            style: kHeading,
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
                      hintText: "Profile Name",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        profileName = text;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return colorList[currentColorIndex];
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            toggleColor();
                          });
                        },
                        child: Text(
                          'Color',
                          style: kButtonLabel,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff581845)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xff581845)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Profile successfully added')));
                            addProfile(profileName, currentColorIndex, []);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Add',
                          style: kButtonLabel,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  //function to call when the user wants to edit an existing profile.
  Future<void> editProfilePopup() async {
    String editprofileName = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Edit Profile',
            style: kHeading,
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
                      hintText: currentProfile,
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        editprofileName = text;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return colorList[currentColorIndex];
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            toggleColor();
                          });
                        },
                        child: Text(
                          'Color',
                          style: kButtonLabel,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 30,
                      width: 90,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff581845)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xff581845)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Profile successfully edited')));
                            editProfile(currentProfile, editprofileName, currentColorIndex);
                            setState(() {
                              currentProfile = editprofileName;
                              getClassList(currentProfile);
                              getClassColor(currentProfile);
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Save',
                          style: kButtonLabel,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // function to call when the user wants to add a new notification.
  Future<void> addNotificationPopup() async {
    String addNotifTitle, addNotifDesc;
    DateTime addNotifDateTime = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: const Text(
                'Add Notification',
                style: kHeading,
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // title textfield
                        InputAccountCard(
                          hintText: "Title",
                          width: 300,
                          validator: (String value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            addNotifTitle = text;
                          },
                        ),
                        // textfieldform ba talaga tong sa time???
                        Container(
                          width: 300,
                          child: DateTimeField(
                            decoration: InputDecoration(
                              hintText: 'Please select the notification date and time',
                              border: OutlineInputBorder()
                            ),
                            selectedDate: addNotifDateTime,
                            onDateSelected: (DateTime value) {
                              addNotifDateTime = value;
                              setState(() {
                                print(addNotifDateTime);
                              });
                            }  
                          ),
                        ),
                        




                        // like inputAccountCard pero may additional sht sa textformfield for multiline
                        // description textfield
                        Container(
                          margin: EdgeInsets.all(5.0),
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0)),
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 5,
                              textAlign: TextAlign.center,
                              cursorColor: Colors.black,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Description",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[300]),
                              ),
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                addNotifDesc = text;
                              },
                            ),
                          ),
                        ),
                        // choose class based on accounts in profile?
                        // click to add the notification
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          height: 30,
                          width: 90,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff581845)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Color(0xff581845)),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()){
                                addNotification(addNotifTitle, addNotifDesc, addNotifDateTime);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Notification successfully set')));
                                checkNotifications();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Set',
                              style: kButtonLabel,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // function to call when the user wants to edit an existing notification.
  Future<void> editNotificationPopup(String notifTitle, String notifDesc, DateTime notifDateTime) async {
    String editNotifTitle, editNotifDesc;
    DateTime editNotifDateTime = notifDateTime;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: const Text(
                'Edit Notification',
                style: kHeading,
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // title textfield
                        InputAccountCard(
                          hintText: notifTitle,
                          width: 300,
                          validator: (String value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            editNotifTitle = text;
                          },
                        ),
                        // textfieldform ba talaga tong sa time???
                        Container(
                          width: 300,
                          child: DateTimeField(
                            decoration: InputDecoration(
                              hintText: 'Please select the notification date and time',
                              border: OutlineInputBorder()
                            ),
                            selectedDate: editNotifDateTime,
                            onDateSelected: (DateTime value) {
                              editNotifDateTime = value;
                              setState(() {
                                print(editNotifDateTime);
                              });
                            }  
                          ),
                        ),
                        




                        // like inputAccountCard pero may additional sht sa textformfield for multiline
                        // description textfield
                        Container(
                          margin: EdgeInsets.all(5.0),
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0)),
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 5,
                              textAlign: TextAlign.center,
                              cursorColor: Colors.black,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Description",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[300]),
                              ),
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                editNotifDesc = text;
                              },
                            ),
                          ),
                        ),
                        // choose class based on accounts in profile?
                        // click to add the notification
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          height: 30,
                          width: 90,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff581845)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Color(0xff581845)),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()){
                                editNotification(notifTitle, notifDesc, notifDateTime, editNotifTitle, editNotifDesc, editNotifDateTime);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Notification successfully changed')));
                                checkNotifications();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Set',
                              style: kButtonLabel,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // function to call when the user wants to view the content of a notification
  // used when a notification is clicked
  Future<void> viewNotificationPopup(
      String notifTitle, DateTime notifDateTime, String notifDesc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // color based on color of class?
          backgroundColor: Color(0xff43aa8b),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  editNotificationPopup(notifTitle, notifDesc, notifDateTime);
                },
              ),
              Text(
                notifTitle,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteNotification(notifTitle);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification successfully removed')));
                },
              ),
            ],
          ),
          

          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              width: 300,
              child: Column(
                children: [
                  // separate header from content
                  Divider(
                    indent: 60,
                    endIndent: 60,
                    color: Colors.white,
                    height: 10,
                    thickness: 5,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    notifDateTime.toString(),
                    style: kViewBody,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    notifDesc,
                    style: kViewBody,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  //function to call once the notfication time has been reached.
  Future<void> alertNotificationPopup(
      String notifTitle, DateTime notifDateTime, String notifDesc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // color based on color of class?
          backgroundColor: Colors.red,
          title: Text(
            notifTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              width: 300,
              child: Column(
                children: [
                  // separate header from content
                  Divider(
                    indent: 60,
                    endIndent: 60,
                    color: Colors.white,
                    height: 10,
                    thickness: 5,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    notifDateTime.toString(),
                    style: kViewBody,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    notifDesc,
                    style: kViewBody,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    deleteNotification(notifTitle);
  }

  //function to call to add notifcation data to database.
  Future<void> addNotification(String notifTitle, String notifDesc,
      DateTime notifDateTime) {
    
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'data_count': FieldValue.increment(1)
        })
        .then((value) => print("data count increased"))
        .catchError((error) => print("Failed to increase data count: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'title_list': FieldValue.arrayUnion([notifTitle])
        })
        .then((value) => print("Profile Name Added"))
        .catchError((error) => print("Failed to add profilename: $error"));

    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'data' : FieldValue.arrayUnion([
            {
              'title' : notifTitle,
              'time' : notifDateTime,
              'desc' : notifDesc
            }
          ])
        })
        .then((value) => print("Notif Added"))
        .catchError((error) => print("Failed to add notif: $error"));
  }

  //function to call to edit existing notifcation data in database.
  Future<void> editNotification(String notifTitle, String notifDesc,
      DateTime notifDateTime, String editNotifTitle, String editNotifDesc, DateTime editNotifDateTime) {
    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'title_list': FieldValue.arrayRemove([notifTitle])
        })
        .then((value) => print("Profile Name Added"))
        .catchError((error) => print("Failed to add profilename: $error"));
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'title_list': FieldValue.arrayUnion([editNotifTitle])
        })
        .then((value) => print("Profile Name Added"))
        .catchError((error) => print("Failed to add profilename: $error"));
    
    FirebaseFirestore.instance
    .collection(auth.currentUser.uid)
    .doc('notifications')
    .update({
      'data' : FieldValue.arrayRemove([
        {
          'title' : notifTitle,
          'time' : notifDateTime,
          'desc' : notifDesc
        }
      ])
    })
    .then((value) => print("User Added"))
    .catchError((error) => print("Failed to add user: $error"));
    
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'data' : FieldValue.arrayUnion([
            {
              'title' : editNotifTitle,
              'time' : editNotifDateTime,
              'desc' : editNotifDesc
            }
          ])
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //function to call to delete notifcation data to database.
  Future<void> deleteNotification(String notifTitle) {
    List<dynamic> currData = [];
    int titleIndex;
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .get()
        .then((DocumentSnapshot ds) {
          if (ds.exists){
            currData = ds.data()['data'];
            List<dynamic> titleList = ds.data()['title_list'];
            titleIndex = titleList.indexOf(notifTitle);
            print('currData: $currData');
            currData.removeAt(titleIndex);
            print('currData after removal: $currData');
            print(titleIndex);
          }
        })
        .catchError((error) => print("Failed to retrieve notif data: $error"));


    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'data_count': FieldValue.increment(-1),
        })
        .then((value) => print("Data Count reduced"))
        .catchError((error) => print("Failed to reduce data count: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update({
          'title_list': FieldValue.arrayRemove([notifTitle])
        })
        .then((value) => print("Notif Title removed"))
        .catchError((error) => print("Failed to delete notif title: $error"));

    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('notifications')
        .update(
          {
            'data' : currData
          }
        )
        .then((value) => print("Notification deleted"))
        .catchError((error) => print("Failed to remove notif: $error"));
  }

  //function to call to check scheduled notifcations for today from database.
  void checkNotifications() {
    print("check notif called");
    FirebaseFirestore.instance
    .collection(auth.currentUser.uid)
    .doc('notifications')
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          var notifData = documentSnapshot.data()['data'];
          DateTime now = DateTime.now();
          DateTime formatted = DateTime(now.year, now.month, now.day);
          for (Map<String, dynamic> acc in notifData){
            acc.forEach((key, value) {
              if (key == 'time'){
                DateTime saved = DateTime(value.toDate().year,value.toDate().month, value.toDate().day);
                if (formatted == saved && value.toDate().compareTo(now) >= 0){
                  TimeScheduler()
                  .run(() {
                    alertNotificationPopup(acc['title'], acc['time'].toDate(), acc['desc']);
                  },
                  value.toDate());
                }

              }
            });
          }
          
        });

        print(accData);
        print(accounts);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  // function to call when the user wants to add data to the database.
  Future<void> addAccount(String profileName, String addAccName,
      String addEmail, String addPass, String addURL) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .update({
          'accounts' : FieldValue.arrayUnion([
            {
            addAccName: {
              'email': addEmail,
              'password': encryptPass(addPass).base64,
              'website url': addURL
              }
            }
          ])
        },  )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // function to call when the user wants to edit data in the database.
  Future<void> editAccount(String profileName, String accName, String editEmail,
      String editPass, String editURL) {
        accData['accounts'][accounts.indexOf(accName)][accName]['password'] = encryptPass(editPass).base64;
        accData['accounts'][accounts.indexOf(accName)][accName]['email'] = editEmail;
        accData['accounts'][accounts.indexOf(accName)][accName]['website url'] = editURL;

    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .update(accData)
        .then((value) => print("Account successfully edited"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // function to call when the user wants to delete account entry in the database.
  Future<void> deleteAccount(String profileName, String accName) {
    // Call the user's CollectionReference to add a new user
    accData['accounts'].remove(accounts.indexOf(accName));
    print('after deletion: $accData');
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .update(
          {
            'accounts' : FieldValue.arrayRemove([accData['accounts'][accounts.indexOf(accName)]])
          }
        )
        .then((value) => print("Account deleted"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // function to call when the user wants to add data to the database.
  Future<void> addProfile(String profileName, int colorIndex, List data) {
    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .set({
          'color': {profileName: colorIndex}
        }, SetOptions(merge: true))
        .then((value) => print("Color Map Added"))
        .catchError((error) => print("Failed to add color map: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_count': FieldValue.increment(1),
        })
        .then((value) => print("Color Count Added"))
        .catchError((error) => print("Failed to add color count: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_names': FieldValue.arrayUnion([profileName])
        })
        .then((value) => print("Profile Name Added"))
        .catchError((error) => print("Failed to add profilename: $error"));

    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .set({
          'accounts' : data
        })
        .then((value) => print("Profile Added"))
        .catchError((error) => print("Failed to add profile: $error"));
  }
  
  //function to call when the user wants to edit profile data (name and color) in the database
  Future<void> editProfile(String profileName, String editprofileName, int colorIndex) {
    // Call the user's CollectionReference to add a new user
    
    deleteProfile(profileName);
    addProfile(editprofileName, colorIndex, accData['accounts']);
    return null;
  }

  //function to call when the user wants to delete profile and accounts in the database
  Future<void> deleteProfile(String profileName) {
    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .set({
          'color': {profileName: FieldValue.delete()}
        }, SetOptions(merge: true))
        .then((value) => print("Color Map entry deleted"))
        .catchError((error) => print("Failed to delete color map: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_count': FieldValue.increment(-1),
        })
        .then((value) => print("Color Count reduced"))
        .catchError((error) => print("Failed to delete color count: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_names': FieldValue.arrayRemove([profileName])
        })
        .then((value) => print("Profile Name removed"))
        .catchError((error) => print("Failed to delete profilename: $error"));

    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .delete()
        .then((value) {print("Profile delete successfully");
        }).catchError((error) => print("Failed to delete profile: $error"));
  }

  // function to call when the user wants to signout.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // function to call to update the local class list.
  void getClassList(String profileName) {
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection('profile_names')
        .doc(profileName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          accounts = [];
          accData = documentSnapshot.data();

          for (Map<String, dynamic> acc in accData['accounts']){
            acc.forEach((key, value) {
              accounts.add(key);
            });
          }
          
        });

        print(accData);
        print(accounts);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  //function to call to get the profile color scheme from database
  void getClassColor(String profileName) {
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> test = documentSnapshot.data();
        print(test['color'][profileName]);
        setState(() {
          currentClassColor = test['color'][profileName];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  // function to call to change preferred color.
  void toggleColor() {
    if (currentColorIndex < colorList.length) {
      currentColorIndex += 1;
    } else {
      currentColorIndex = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    print(auth.currentUser.uid);
    checkNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // just used to mess with the placeholder background.
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          tooltip: "Logout",
          onPressed: () {
            print("Logout pressed");
            _signOut();
            Navigator.pop(context);
          },
        ),
        title: Text(currentProfile),
        backgroundColor: Color(0xff581845),
      ),
      backgroundColor: Color(0xff581845),
      body: SlidingUpPanel(
        controller: panelController,
        onPanelSlide: (double size) {
          // hide panel content until partially opened.
          setState(() {
            panelOpacity = size;
          });
        },
        // content of the panel
        panelBuilder: (ScrollController sc) {
          final PageController pc = PageController(initialPage: 0);
          final ScrollController sc2 = ScrollController();
          return Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pc,
                  children: [
                    // first page. contains the profiles
                    Opacity(
                      opacity: panelOpacity,
                      child: Container(
                        child: Column(
                          children: [
                            // kinda like the header
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: IconButton(
                                      onPressed: () {
                                        editProfilePopup();
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color(0xff581845),
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Profiles',
                                    style: kHeading,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: IconButton(
                                      onPressed: () {
                                        deleteProfile(currentProfile);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Deleted Successfully')));
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color(0xff581845),
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // the scrollable view of profiles
                            Expanded(
                              flex: 6,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(auth.currentUser.uid)
                                    .doc('profiles')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      ),
                                    );
                                  }
                                  int _itemcount =
                                      snapshot.data.data()['profile_count'];
                                  return Scrollbar(
                                    child: ListView.separated(
                                      controller: sc,
                                      padding: const EdgeInsets.all(8),
                                      itemCount: _itemcount,
                                      // to display all the profiles. add the backend stuff here to replace the placeholder profiles list??
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String item = snapshot.data
                                            .data()['profile_names'][index];
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: size.height / 8),
                                          height: 50.0,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      (currentProfile == item)
                                                          ? Colors.pink
                                                          : Color(0xff43aa8b)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Color(0xff43aa8b)),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                currentProfile = item;
                                                getClassList(currentProfile);
                                                getClassColor(currentProfile);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Profile "$currentProfile" selected.')));
                                              panelController.close();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(width: 40.0),
                                                Text(
                                                  item,
                                                  style: kButtonLabel,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
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
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(height: 20.0),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    addProfilePopup();
                                  },
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
                    ),
                    // the second page. contains the notifications
                    Opacity(
                      opacity: panelOpacity,
                      child: Container(
                        child: Column(
                          children: [
                            // kinda like the header
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Notifications',
                                  style: kHeading,
                                ),
                              ),
                            ),
                            // the scrollable view of notifications
                            Expanded(
                              flex: 6,
                              child:StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(auth.currentUser.uid)
                                    .doc('notifications')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      ),
                                    );
                                  }
                                  int _itemcount = snapshot.data.data()['data_count'];
                                  return Scrollbar(
                                    child: ListView.separated(
                                      controller: sc2,
                                      padding: const EdgeInsets.all(8),
                                      itemCount: _itemcount,
                                      // to display all the profiles. add the backend stuff here to replace the placeholder profiles list??
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String item = snapshot.data
                                            .data()['data'][index]['title'];
                                        List<dynamic> titleList = snapshot.data.data()['title_list'];
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: size.height / 8),
                                          height: 50.0,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      (currentProfile == item)
                                                          ? Colors.pink
                                                          : Color(0xff43aa8b)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Color(0xff43aa8b)),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              viewNotificationPopup(item, snapshot.data.data()['data'][titleList.indexOf(item)]['time'].toDate(), snapshot.data.data()['data'][titleList.indexOf(item)]['desc']);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(width: 40.0),
                                                Text(
                                                  item,
                                                  style: kButtonLabel,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
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
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(height: 20.0),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    addNotificationPopup();
                                  },
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
                    ),
                  ],
                ),
              ),
              // contains the page indicator
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 20.0),
                child: SmoothPageIndicator(
                  controller: pc, // PageController
                  count: 2,
                  effect: ScrollingDotsEffect(
                    activeStrokeWidth: 2.6,
                    activeDotScale: 1.0,
                    dotHeight: 10,
                    dotWidth: 10,
                    radius: 8,
                    spacing: 10,
                    activeDotColor: Color(0xff581845),
                    fixedCenter: true,
                  ),
                ),
              ),
            ],
          );
        },
        collapsed: Center(
          child: Icon(Icons.keyboard_arrow_up),
        ),
        minHeight: 70.0,
        maxHeight: 550.0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        backdropEnabled: true,
        // the placeholder background that displays accounts (accounts)
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
                  children: accounts
                      .map(
                        (accName) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorList[currentClassColor],
                            ),
                            child: TextButton(
                              onPressed: () {
                                viewAccountPopup(
                                    accName,
                                    accData['accounts'][accounts.indexOf(accName)][accName]['email'],
                                    decryptPass(accData['accounts'][accounts.indexOf(accName)][accName]['password']),
                                    accData['accounts'][accounts.indexOf(accName)][accName]['website url'],
                                    'https://i.insider.com/5abb9eb43216742a008b45cc?width=1200&format=jpeg');
                              },
                              child: Center(
                                child: Text(
                                  accName,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              // part of the placeholder which the user clicks to add an account
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentProfile != '') {
            addAccountPopup();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select a profile first!')));
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}

// A custom widget used in the add account popup. Just adds styling to avoid repetition.
class InputAccountCard extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChanged;
  final double width;
  InputAccountCard({this.hintText, this.validator, this.onChanged, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: width ?? 200,
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
