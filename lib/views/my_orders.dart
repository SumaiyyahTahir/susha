import 'package:firebase_susha/firebase_susha.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {

  const MyOrdersScreen({Key? key}) : super(key: key);
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  Future<List<SushaOrder>>? _getOrders;
  late Future<User?> getUser;
  late User user;
  late String uid;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    uid = AuthService.firebase().currentUser?.uid ?? "";
    User? fetchedUser = await UserFirestoreService().getUser(uid);
    
    setState(() {
      user = fetchedUser!;
      List<String> allOrderIds = user.completedOrderIds + user.pendingOrderIds;
      if(allOrderIds.isNotEmpty){
        _getOrders = fetchOrders(allOrderIds);
      }
    });
  }

  Future<List<SushaOrder>> fetchOrders(List<String> orderIds) async {
    final OrderFirestoreService firestoreService = OrderFirestoreService();
    final List<SushaOrder> orders = await firestoreService.getOrders(orderIds);
    return orders;
  }

  Future<List<Shoe>> fetchShoes(SushaOrder order) async {
    final List<Shoe> shoes = await ShoeFirestoreService().getShoesByIds(order.shoeIds);
    return shoes;
  }

  Widget buildOrderList(List<SushaOrder> orders) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final SushaOrder order = orders[index];
          return Card(
            child: Column(
              children: [
                if (user.pendingOrderIds.contains(order.orderId))
                  const Text('Pending Order', style: TextStyle(fontWeight: FontWeight.bold))
                else
                  const Text('Completed Order', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Order ID: ${order.orderId}'),
                FutureBuilder<List<Shoe>>(
                  future: fetchShoes(order),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final List<Shoe> shoes = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shoes.length,
                        itemBuilder: (context, index) {
                          final Shoe shoe = shoes[index];
                          return ListTile(
                            title: Text(shoe.model, style: const TextStyle(fontSize: 15),),
                            subtitle: Text(shoe.price, style: const TextStyle(fontSize: 15),),
                            // Display other shoe details as needed
                          );
                        },
                      );
                    } else {
                      return const Text('No shoes found for this order.');
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Orders'),
      ),
      body: FutureBuilder<List<SushaOrder>>(
        future: _getOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<SushaOrder> orders = snapshot.data!;
            return buildOrderList(orders);
          } else {
            return const Center(child: Text('No orders found.'));
          }
        },
      ),
    );
  }
}
