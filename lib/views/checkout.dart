// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import 'buttons.dart';

class Checkout extends StatefulWidget {
  final SushaOrder order;
  const Checkout({super.key, required this.order});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String _selectedShippingOption = '';
  String _selectedPaymentOption = '';
  String costString = '';

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
          title: const Text('Checkout'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: FutureBuilder<List<Shoe>>(
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
                    const Text('Shipping Options: '),
                    RadioListTile(
                      title: const Text(
                        'Standard Shipping (Rs.150)',
                      ),
                      value: '150',
                      groupValue: _selectedShippingOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedShippingOption = value.toString();
                          double shippingCost = double.parse(value.toString());
                          double shoesPrice =
                              double.parse(widget.order.shoesPrice);
                          double totalCost = shippingCost + shoesPrice;
                          costString = totalCost.toStringAsFixed(2);
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text(
                        'Express Shipping (Rs.250)',
                      ),
                      value: '250',
                      groupValue: _selectedShippingOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedShippingOption = value.toString();
                          double shippingCost = double.parse(value.toString());
                          double shoesPrice =
                              double.parse(widget.order.shoesPrice);
                          double totalCost = shippingCost + shoesPrice;
                          costString = totalCost.toStringAsFixed(2);
                        });
                      },
                    ),
                    const Text('Payment Options:'),
                    RadioListTile(
                      title: const Text('Cash on Delivery'),
                      value: 'cash',
                      groupValue: _selectedPaymentOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentOption = value as String;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping Cost:'),
                        Text('Rs. $_selectedShippingOption'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Cost:'),
                        Text(
                          'Rs. $costString',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    MyButton(
                      text: 'Place Order',
                      onButtonPressed: () async {
                        if (_selectedPaymentOption.isNotEmpty &&
                            _selectedShippingOption.isNotEmpty) {
                          SushaOrder updatedOrder = SushaOrder(
                              orderId: '',
                              userId: widget.order.userId,
                              name: widget.order.name,
                              email: widget.order.email,
                              contact: widget.order.contact,
                              shoeIds: widget.order.shoeIds,
                              dateOfOrder: Timestamp.now(),
                              addressLine1: widget.order.addressLine1,
                              addressLine2: widget.order.addressLine2,
                              addressCity: widget.order.addressCity,
                              addressCountry: widget.order.addressCountry,
                              coordinates: widget.order.coordinates,
                              deliveryCharges: _selectedShippingOption,
                              shoesPrice: widget.order.shoesPrice,
                              totalPrice: costString,
                              discount: '0',
                              deliveryStatus: 'pending',
                              paymentStatus: 'pending');
                          SushaOrder order = await OrderFirestoreService()
                              .placeOrder(updatedOrder);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              orderConfirmed, arguments: order, (context) => false);
                        }
                      },
                    ),
                  ],
                );
              }),
        ));
  }
}
