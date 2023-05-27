import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/src/constants/firestore_keys.dart';

class Shoe {
  final String productId;
  final String imageUrl;
  final String model;
  final String size;
  final String color;
  final String description;
  final String gender;
  final String category;
  final String price;
  final bool isSold;

  Shoe({
    required this.productId,
    required this.imageUrl,
    required this.model,
    required this.size,
    required this.color,
    required this.description,
    required this.gender,
    required this.category,
    required this.price,
    required this.isSold,
  });

  factory Shoe.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Shoe(
      productId: snapshot.id,
      imageUrl: data[FirestoreConstants.imageUrlField] as String,
      model: data[FirestoreConstants.modelField] as String,
      size: data[FirestoreConstants.sizeField] as String,
      color: data[FirestoreConstants.colorField] as String,
      description: data[FirestoreConstants.descriptionField] as String,
      gender: data[FirestoreConstants.genderField] as String,
      category: data[FirestoreConstants.categoryField] as String,
      price: data[FirestoreConstants.priceField] as String,
      isSold: data[FirestoreConstants.isSoldField] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.productIdField: productId,
      FirestoreConstants.imageUrlField: imageUrl,
      FirestoreConstants.modelField: model,
      FirestoreConstants.sizeField: size,
      FirestoreConstants.colorField: color,
      FirestoreConstants.descriptionField: description,
      FirestoreConstants.genderField: gender,
      FirestoreConstants.categoryField: category,
      FirestoreConstants.priceField: price,
      FirestoreConstants.isSoldField: isSold,
    };
  }
}
