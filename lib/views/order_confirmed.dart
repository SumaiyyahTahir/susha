import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import 'buttons.dart';

class OrderConformedScreen extends StatefulWidget {
  final SushaOrder order;
  const OrderConformedScreen({super.key, required this.order});

  @override
  State<OrderConformedScreen> createState() => _OrderConformedScreenState();
}

class _OrderConformedScreenState extends State<OrderConformedScreen> {
  Future<List<Shoe>> fetchShoes() async {
    if (widget.order.shoeIds.isNotEmpty) {
      final List<Shoe> shoes =
          await ShoeFirestoreService().getShoesByIds(widget.order.shoeIds);
      return shoes;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  FutureBuilder<List<Shoe>>(
                    future: fetchShoes(),
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
                          Column(
                            children: List.generate(shoes.length, (index) {
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
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Hero(
                            tag: 'logotag4',
                            child: Icon(
                              Icons.thumb_up,
                              size: 80.0,
                            ),
                          ),
                          const Text('Your order has been confirmed!'),
                          const SizedBox(height: 16),
                          Text('Order ID: ${widget.order.orderId}'),
                          Text(
                              'Shoes in Order: ${widget.order.shoeIds.join(", ")}'),
                          Text('Shoes Price: ${widget.order.shoesPrice}'),
                          Text(
                              'Delivery Charges: ${widget.order.deliveryCharges}'),
                          Text('Total Price: ${widget.order.totalPrice}'),
                          Text(
                              'Date of Order: ${widget.order.dateOfOrder.toDate().toString()}'),
                          Text('Name: ${widget.order.name}'),
                          Text(
                              'Address: ${widget.order.addressLine1}, ${widget.order.addressLine2}, ${widget.order.addressCity}, ${widget.order.addressCountry}'),
                          Text(
                              'Delivery Status: ${widget.order.deliveryStatus}'),
                          Text('Payment Status: ${widget.order.paymentStatus}'),
                          MyButton(
                            text: 'Head back to dashboard',
                            onButtonPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(bottomNav);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
