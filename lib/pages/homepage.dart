import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:log_in_app/services/authentication_service.dart';
import 'package:log_in_app/model/user_model.dart';
import 'package:log_in_app/pages/sign_in_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel signedInUser = UserModel();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      signedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: Image.asset(
            "assets/logo2.png",
            fit: BoxFit.contain,
          ),
          title: const Text(
            'KelTech',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.red,
                  elevation: 0,
                ),
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.push(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                },
                child: const Text('Sign Out!'),
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 40),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          "images/welcome2.svg",
                          height: 500,
                          width: 2,
                          fit: BoxFit.fill,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${signedInUser.firstName} ${signedInUser.surname}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Your Email is \n\n${signedInUser.email}',
                      style: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          "images/done2.svg",
                          fit: BoxFit.contain,
                        )),
                        const SizedBox(
                      height: 70,
                    ),
                   const Text(
                      'Thank you for visiting my App',
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
