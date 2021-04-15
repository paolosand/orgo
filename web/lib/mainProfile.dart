import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// A constant body textstyle used in the view account popup
const TextStyle kViewBody = TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w700);

class MainProfile extends StatefulWidget {
  const MainProfile({Key key}) : super(key: key);
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PanelController panelController = PanelController();
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> classes = [];
  Map<String, dynamic> accData = {};
  String currentProfile = "";
  int currentClassColor = 0;

  List<MaterialColor> colorList = Colors.primaries;
  int currentColorIndex = 0;

  bool panelVisible = false; // to hide the contents of the panel when collapsed.
  // function to call when the user wants to add an account.
  Future<void> addAccountPopup() async {
    String addAccName, addEmail, addPass, addURL;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Add Account',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
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
                        else if (classes.contains(value)){
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account data successfully added')));
                            addAccount(currentProfile, addAccName, addEmail, addPass, addURL);
                            getClassList(currentProfile);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account data successfully changed')));
                            editAccount(currentProfile, accName, editEmail, editPass, editURL);
                            getClassList(currentProfile);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
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
                  onPressed: (){
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
                  onPressed: (){
                    deleteAccount(currentProfile, accountTitle);
                    getClassList(currentProfile);
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account successfully removed')));
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

  // function to call when the user wants to add a new profile.
  Future<void> addProfilePopup() async {
    String profileName = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Add Profile',
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
                      hintText: "Profile Name",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text){
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
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
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
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile successfully added')));
                            addProfile(profileName, currentColorIndex);
                            Navigator.of(context).pop();
                          }

                        },
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
      }
    );
  }

  // function to call when the user wants to add data to the database.
  Future<void> addAccount(String profileName, String addAccName, String addEmail, String addPass, String addURL) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection(profileName)
        .doc('accounts')
        .update({
          addAccName : {
            'email' : addEmail,
            'password' : addPass,
            'website url' : addURL
          }
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // function to call when the user wants to edit data in the database.
  Future<void> editAccount(String profileName, String accName, String editEmail, String editPass, String editURL) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection(profileName)
        .doc('accounts')
        .update({
          accName : {
            'email' : editEmail,
            'password' : editPass,
            'website url' : editURL
          }
        })
        .then((value) => print("Account successfully edited"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // function to call when the user wants to delete account entry in the database.
  Future<void> deleteAccount(String profileName, String accName) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection(profileName)
        .doc('accounts')
        .update({
          accName : FieldValue.delete()
        })
        .then((value) => print("Account deleted"))
        .catchError((error) => print("Failed to add user: $error"));
  }



  // function to call when the user wants to add data to the database.
  Future<void> addProfile(String profileName, int colorIndex) {
    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .set({
          'color' : {
            profileName : colorIndex
          }
        }, SetOptions(merge: true))
        .then((value) => print("Color Map Added"))
        .catchError((error) => print("Failed to add color map: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_count' : FieldValue.increment(1),
        })
        .then((value) => print("Color Count Added"))
        .catchError((error) => print("Failed to add color count: $error"));
    
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_names' : FieldValue.arrayUnion([profileName])
        })
        .then((value) => print("Profile Name Added"))
        .catchError((error) => print("Failed to add profilename: $error"));
    
    
    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection(profileName)
        .doc('accounts')
        .set({})
        .then((value) => print("Profile Added"))
        .catchError((error) => print("Failed to add profile: $error"));
  }

  Future<void> deleteProfile(String profileName) {
    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .set({
          'color' : {
            profileName : FieldValue.delete()
          }
        }, SetOptions(merge: true))
        .then((value) => print("Color Map entry deleted"))
        .catchError((error) => print("Failed to delete color map: $error"));

    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_count' : FieldValue.increment(-1),
        })
        .then((value) => print("Color Count reduced"))
        .catchError((error) => print("Failed to delete color count: $error"));
    
    FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .update({
          'profile_names' : FieldValue.arrayRemove([profileName])
        })
        .then((value) => print("Profile Name removed"))
        .catchError((error) => print("Failed to delete profilename: $error"));
    

    WriteBatch batch = FirebaseFirestore.instance.batch();

    return FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .doc('profiles')
        .collection(profileName)
        .get()
        .then((value) {
          value.docs.forEach((document) {batch.delete(document.reference);});
        })
        .catchError((error) => print("Failed to delete profile: $error"));
  }



  // function to call when the user wants to signout.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // function to call to update the local class list.
  void getClassList(String profileName){
    FirebaseFirestore.instance
      .collection(auth.currentUser.uid)
      .doc('profiles')
      .collection(profileName)
      .doc('accounts')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          classes = [];
          accData = documentSnapshot.data();
          accData.forEach((key, value) {
            classes.add(key);
          });
        });

        print(accData);
        print(classes);

      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void getClassColor(String profileName){
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
          onPressed: (){
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
                            onPressed: () {
                              deleteProfile(currentProfile);

                            },
                            icon: Icon(
                              Icons.delete,
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
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection(auth.currentUser.uid).doc('profiles').snapshots(),
                      builder: (context, snapshot){
                        if (snapshot.data == null){
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          );
                        }
                        int _itemcount = snapshot.data.data()['profile_count'];
                        return Scrollbar(
                          child: ListView.separated(
                            controller: sc,
                            padding: const EdgeInsets.all(8),
                            itemCount: _itemcount,
                            // to display all the profiles. add the backend stuff here to replace the placeholder profiles list??
                            itemBuilder: (BuildContext context, int index) {
                              String item = snapshot.data.data()['profile_names'][index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.height / 8),
                                height: 50.0,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        (currentProfile == item)? Colors.pink : Color(0xff43aa8b)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(color: Color(0xff43aa8b)),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      currentProfile = item;
                                      getClassList(currentProfile);
                                      getClassColor(currentProfile);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile "$currentProfile" selected.')));
                                    panelController.close();
                                  },
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
                        );
                      },
                    )
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
                                    accData[accName]['email'],
                                    accData[accName]['password'],
                                    accData[accName]['website url'],
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
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a profile first!')));
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
