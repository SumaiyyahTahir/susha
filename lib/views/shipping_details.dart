import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:susha/services/location/get_placemark.dart';

import '../constants/routes.dart';
import 'buttons.dart';

class ShippingDetailsForm extends StatefulWidget {
  final SushaOrder order;
  const ShippingDetailsForm({Key? key, required this.order}) : super(key: key);

  @override
  State<ShippingDetailsForm> createState() => _ShippingDetailsFormState();
}

class _ShippingDetailsFormState extends State<ShippingDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  String _locationText = 'Select Location';
  late LatLng _location = const LatLng(0, 0);

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Details'),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              controller: _fullNameController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address Line 1',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              controller: _addressLine1Controller,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address Line 2 (optional)',
              ),
              controller: _addressLine2Controller,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'City',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
              controller: _cityController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Country',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your country';
                }
                return null;
              },
              controller: _countryController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone number',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              controller: _numberController,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Location'),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, selectLocationRoute)
                    .then((location) {
                  if (location != null) {
                    setState(() {
                      _location = location as LatLng;
                    });

                    getPlace(_location).then((value) {
                      setState(() {
                        _addressLine1Controller.text = "${value.name}";
                        if (value.thoroughfare != "") {
                          _addressLine2Controller.text =
                              "${value.thoroughfare}";
                        }
                        _cityController.text =
                            "${value.subAdministrativeArea}, ${value.administrativeArea}";
                        _countryController.text = "${value.country}";
                        _locationText =
                            "${_location.latitude}, ${_location.longitude}";
                      });
                    });
                  }
                });
              },
              child: Container(
                decoration: const BoxDecoration(
                  border:
                      BorderDirectional(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _locationText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 116, 114, 114),
                        ),
                      ),
                    ),
                    const IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
            MyButton(
              text: 'Proceed to Checkout',
              onButtonPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  SushaOrder updatedOrder = SushaOrder(
                      orderId: '',
                      userId: widget.order.userId,
                      name: _fullNameController.text,
                      email: _emailController.text,
                      contact: _numberController.text,
                      shoeIds: widget.order.shoeIds,
                      dateOfOrder: widget.order.dateOfOrder,
                      addressLine1: _addressLine1Controller.text,
                      addressLine2: _addressLine2Controller.text,
                      addressCity: _cityController.text,
                      addressCountry: _countryController.text,
                      coordinates:
                          GeoPoint(_location.latitude, _location.longitude),
                      deliveryCharges: '',
                      shoesPrice: widget.order.shoesPrice,
                      totalPrice: '',
                      discount: '',
                      deliveryStatus: 'pending',
                      paymentStatus: 'pending');
                  Navigator.of(context)
                      .pushNamed(checkout, arguments: updatedOrder);
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}



                  // print('Full Name: ${_fullNameController.text}');
                  // print('Email: ${_emailController.text}');
                  // print('Address Line 1: ${_addressLine1Controller.text}');
                  // print('Address Line 2: ${_addressLine2Controller.text}');
                  // print('City: ${_cityController.text}');
                  // print('Country: ${_countryController.text}');
                  // print('Phone Number: ${_numberController.text}');