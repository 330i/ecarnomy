import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'signin.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tamuhackprojectlol/pages/home_page.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 2*MediaQuery.of(context).size.height/5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          'Hello There',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle_outlined,
                        size: 25,
                        color: Colors.black54,
                      ),
                      Container(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width-111,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        size: 25,
                        color: Colors.black54,
                      ),
                      Container(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width-111,
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.vpn_key_outlined,
                        size: 25,
                        color: Colors.black54,
                      ),
                      Container(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width-111,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: NeumorphicButton(
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      color: const Color.fromRGBO(239, 83, 80, 1),
                    ),
                    child: SizedBox(
                      width: 90,
                      height: 33,
                      child: Row(
                        children: const [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
                        FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
                          'uid': value.user!.uid,
                          'name': nameController.text,
                          'email': emailController.text,
                        }).then((value) {
                          Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const HomePage()),ModalRoute.withName('/login'));
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Signin()));
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color.fromRGBO(239, 83, 80, 1),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}