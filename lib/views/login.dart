// ignore_for_file: use_build_context_synchronously

import 'package:firebase_susha/firebase_susha.dart';
import 'package:flutter/material.dart';
import 'package:susha/views/show_error_dialog.dart';
import '../constants/routes.dart';
import '../firebase_options.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: FirebaseAuthProvider().initialize(
            DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SuSha',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        const Text(
                          'The Shoe Shop',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 4,
                          child: Image.asset(logoImage),
                        ),
                        Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),
                                    child: TextField(
                                      controller: _email,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),
                                    child: TextField(
                                      controller: _password,
                                      obscureText: true,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 35),
                                  GestureDetector(
                                    onTap: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                await AuthService.firebase().logIn(
                                  email: email,
                                  password: password,
                                );
                                final user = AuthService.firebase().currentUser;
                                if (user?.isEmailVerified ?? false) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      bottomNav, (route) => false);
                                } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    verifyEmailRoute, (route) => false);
                              }
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                      bottomNav, (route) => false);
                              } on UserNotFoundAuthException {
                                await showErrorDialog(
                                  context,
                                  'User not found',
                                );
                              } on WrongPasswordAuthException {
                                await showErrorDialog(
                                  context,
                                  'Wrong credentials',
                                );
                              } on GenericAuthException {
                                await showErrorDialog(
                                  context,
                                  'Authentication Error',
                                );
                              }
                            },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black,
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Log In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 35),
                                  const Center(
                                    child: Text(
                                      '- Or -',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(signUp);
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.white38,
                                          ),
                                          child: const Text('Sign Up'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        ),
                    ],
                                  ),
                  ),
              );
              default:
                return const Text('Loading...');
              }
            },
          ),
      ),
      
    );
  }
  
  
}
