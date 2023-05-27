import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> importShoesFromJson() async {
  var fileResponse = await rootBundle.loadString('assets/shoes_collection.json');
   final shoeDataList = json.decode(fileResponse);

  final CollectionReference shoesCollection =
      FirebaseFirestore.instance.collection('shoes');

  for (final shoeData in shoeDataList) {
    final DocumentReference docRef = await shoesCollection.add(shoeData);
    print('Added shoe with ID: ${docRef.id}');
  }
  print(shoeDataList);

  print('Shoes imported successfully.');
}
