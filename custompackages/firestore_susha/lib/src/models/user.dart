import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/src/constants/firestore_keys.dart';

class User {
  String id;
  List<String> pendingOrderIds;
  List<String> completedOrderIds;
  List<String> cartShoes;
  List<String> favShoes;

  User({
    required this.id,
    required this.pendingOrderIds,
    required this.completedOrderIds,
    required this.cartShoes,
    required this.favShoes,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      pendingOrderIds: List<String>.from(data[FirestoreConstants.pendingOrderIdsField] as List<dynamic>),
      completedOrderIds: List<String>.from(data[FirestoreConstants.completedOrderIdsField] as List<dynamic>),
      cartShoes: List<String>.from(data[FirestoreConstants.cartShoesField] as List<dynamic>),
      favShoes: List<String>.from(data[FirestoreConstants.favShoesField] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.pendingOrderIdsField: pendingOrderIds,
      FirestoreConstants.completedOrderIdsField: completedOrderIds,
      FirestoreConstants.cartShoesField: cartShoes,
      FirestoreConstants.favShoesField: favShoes,
    };
  }
}
