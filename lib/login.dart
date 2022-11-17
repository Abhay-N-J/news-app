import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = "", _passwd = "";
  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      appBar: AppBar(title: const Text("Login"), elevation: 16.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 530,
            // height: 100,
            child: Material(
              elevation: 100.0,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: "Email ID",
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                    // print(_email);
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 530,
            child: Material(
              elevation: 100.0,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: "Password",
                ),
                onChanged: (value) {
                  setState(() {
                    _passwd = value.trim();
                    // print(_passwd);
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              // color: Theme.of(context).accentColor,
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 40),
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.red),
              onPressed: () {
                // _auth
                //     .signInWithEmailAndPassword(
                //         email: _email, password: _passwd)
                //     .then((_) {
                //   setState(() {
                //     vis = false;
                //   });
                //   // Navigator.of(context).pushReplacement(
                //   //     MaterialPageRoute(builder: (context) => const Home()));
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil(Home.route, (route) => false);
                // }).catchError((catchError) {
                //   if (_auth.currentUser == null) {
                //     setState(() {
                //       vis = true;
                //     });
                // }
                // });
                AuthenticationHelper()
                    .signIn(email: _email, password: _passwd)
                    .then((result) {
                  if (result == null) {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Home()));
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(Home.route, (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.transparent,
                      behavior: SnackBarBehavior.floating,
                      elevation: 10,
                      content: Container(
                        padding: const EdgeInsets.all(10),
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(result),
                        ),
                      ),
                    ));
                  }
                });
              },
              // color: Theme.of(context).accentColor,
              child: const Text('Sign-in'),
            ),
            // const SizedBox(
            //   width: 10,
            // ),
            ElevatedButton(
              // color: Theme.of(context).accentColor,
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 40),
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.orange),
              child: const Text('Sign-up'),
              onPressed: () {
                // _auth
                //     .createUserWithEmailAndPassword(
                //         email: _email, password: _passwd)
                //     .then((_) {
                //   // Navigator.of(context).pushReplacement(
                //   //     MaterialPageRoute(builder: (context) => const Home()));
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil(Home.route, (route) => false);
                // });
                AuthenticationHelper()
                    .signUp(email: _email, password: _passwd)
                    .then((result) {
                  if (result == null) {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Home()));
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(Home.route, (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.transparent,
                      behavior: SnackBarBehavior.floating,
                      elevation: 10,
                      content: Container(
                        padding: const EdgeInsets.all(10),
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(result),
                        ),
                      ),
                    ));
                  }
                });
              },
            ),
          ]),
          Visibility(
              visible: vis,
              child: const Text(
                "Login failed",
                style: TextStyle(color: Colors.red, fontSize: 50),
              ))
        ],
      ),
    ));
  }
}

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({String email = "", String password = ""}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({String email = "", String password = ""}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
