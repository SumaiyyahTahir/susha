import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_susha/firebase_susha.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import 'package:susha/views/bottom_nav.dart';
import 'package:susha/views/cart.dart';
import 'package:susha/views/checkout.dart';
import 'package:susha/views/dashboard.dart';
import 'package:susha/views/favorites.dart';
import 'package:susha/views/item_info.dart';
import 'package:susha/views/login.dart';
import 'package:susha/views/my_orders.dart';
import 'package:susha/views/order_confirmed.dart';
import 'package:susha/views/shipping_details.dart';
import 'package:susha/views/signup.dart';
import 'package:susha/views/verify_email_view.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';
import 'services/location/map_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //importShoesFromJson();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: const MyHomePage(),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        dashboard: (context) => const Dashboard(),
        checkout: (context) => Checkout(
              order: ModalRoute.of(context)?.settings.arguments as SushaOrder,
            ),
        shippingDeets: (context) => ShippingDetailsForm(
            order: ModalRoute.of(context)?.settings.arguments as SushaOrder),
        bottomNav: (context) => const BottomNav(),
        cart: (context) => const CartScreen(),
        myOrders: (context) => const MyOrdersScreen(),
        orderConfirmed: (context) => OrderConformedScreen(
            order: ModalRoute.of(context)?.settings.arguments as SushaOrder),
        itemInfo: (context) => ItemInfoScreen(
              shoeId:
                  ModalRoute.of(context)?.settings.arguments as String? ?? '',
            ),
        favorites: (context) => const Favorites(),
        signUp: (context) => const SignUpScreen(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        selectLocationRoute: (context) => const MapScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      final user = AuthService.firebase().currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacementNamed(loginRoute);
      } else if (user.isEmailVerified) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(bottomNav, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          child: Text(
            'SuSha',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const DefaultTextStyle(
          style: TextStyle(color: Colors.black),
          child: Text(
            'The Shoe Shop',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.normal),
          ),
        ),
        Image.asset(
          logoImage,
        ),
      ]),
    );
  }
}
