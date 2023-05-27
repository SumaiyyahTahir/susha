import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_susha/firebase_susha.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import 'buttons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<List<Shoe>>? _getShoes;
  late Future<User?> getUser;
  late User user;
  late String uid;
  

  @override
  void initState() {
    super.initState();
    initializeUser();
    
  }

  Future<void> initializeUser() async{
    uid = AuthService.firebase().currentUser?.uid??"";
    User? fetchedUser = await UserFirestoreService().getUser(uid);
    setState(() {
      user = fetchedUser!;
      _getShoes = fetchShoes();
    });
  }

  Future<List<Shoe>> fetchShoes() async {
    final List<Shoe> shoes = await ShoeFirestoreService().getShoesByIds(user.cartShoes);
    return shoes;
  }

  void _removeSelected(String shoeId) async {
    if (user.id != "") {
      if (user.cartShoes.contains(shoeId)) {
        await UserFirestoreService().removeFromCartShoes(user.id, shoeId);
      } 
    }

    await initializeUser();
    setState(() {
      
    });
  }

  double calculateShoesPrice(List<Shoe> shoes) {
  double totalPrice = 0.0;

  for (int i = 0; i < shoes.length; i++) {
    totalPrice += double.parse(shoes[i].price);
  }

  return totalPrice;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: FutureBuilder<List<Shoe>>(
              future: _getShoes,
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
                final List<Shoe>? shoes = snapshot.data;
                if (!snapshot.hasData || shoes == null || shoes.isEmpty) {
                  return const Center(
                    child: Text('No available shoes.'),
                  );
                }
          return Column(
            children: [
              Column(children: 
                List.generate(shoes.length, (index) {
                  final shoe = shoes[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Hero(
                          tag: 'ilogotag',
                          child: Image.network(shoe.imageUrl),
                        ),
                      title: Text(shoe.model),
                      subtitle: Column(
                        children: [
                          Text(
                            shoe.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            shoe.price,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,),
                        onPressed: () {
                          _removeSelected(shoe.productId);
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16,),
              MyButton(
                text: 'Proceed to Shipping', 
                onButtonPressed: () { 
                  
                  SushaOrder order = SushaOrder(orderId: '', userId: uid, name: '', email: '', contact: '', shoeIds: user.cartShoes, dateOfOrder: Timestamp.fromDate(DateTime.now()), addressLine1: '', addressLine2: '', addressCity: '', addressCountry: '', coordinates: const GeoPoint(0,0), deliveryCharges: '', shoesPrice: calculateShoesPrice(shoes).toString(), totalPrice: '', discount: '', deliveryStatus: '', paymentStatus: '');
                  Navigator.of(context).pushNamed(shippingDeets, arguments: order,); 
              },),
              
            ],
          );
          }
        ),
      ),
            
    );
  }
}