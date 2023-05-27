import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:susha/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Verify email'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(35),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Text(
                  "We've sent you an email verification. Please open it to verify your account",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 50,
              ),
              const Text(
                  "If you have not recieved an email, press the button below",
                  style: TextStyle(fontSize: 20)),
              TextButton(
                onPressed: () async {},
                child: const Text('Send email verification'),
              ),
              TextButton(
                onPressed: (() async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    signUp,
                    (route) => false,
                  );
                }),
                child: const Text('Restart'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
