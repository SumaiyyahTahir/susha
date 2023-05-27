// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:firebase_susha/firebase_susha.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import 'package:susha/constants/routes.dart';

import 'buttons.dart';

class ItemInfoScreen extends StatefulWidget {
  final String shoeId;

  const ItemInfoScreen({Key? key, required this.shoeId}) : super(key: key);

  @override
  ItemInfoScreenState createState() => ItemInfoScreenState();
}

class ItemInfoScreenState extends State<ItemInfoScreen> {
  late Future<Shoe> _getShoe;
  final user = AuthService.firebase().currentUser;
  final userService = UserFirestoreService();

  @override
  void initState() {
    super.initState();
    _getShoe = ShoeFirestoreService().getShoeById(widget.shoeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Item Info'),
      ),
      body: FutureBuilder<Shoe>(
        future: _getShoe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No shoe data available.'),
            );
          }

          final shoe = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Card(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Hero(
                        tag: 'logotag3',
                        child: Image.network(shoe.imageUrl),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(),
                  ),
                  Text(
                    shoe.model,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Product Description: ${shoe.description}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  MyButton(
                    text: 'Add to Cart',
                    onButtonPressed: () async {
                        await userService.addToCartShoes(user!.uid, shoe.productId);
                        Navigator.of(context).pushNamed(cart);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
