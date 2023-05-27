import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/src/constants/firestore_keys.dart';
import 'package:firestore_susha/src/models/user.dart';

class UserFirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(FirestoreConstants.usersCollection);

  Future<void> addUser(User user) async {
    await _usersCollection.doc(user.id).set(user.toMap());
  }

  Future<User?> getUser(String userId) async {
    final userSnapshot = await _usersCollection.doc(userId).get();
    if (userSnapshot.exists) {
      return User.fromSnapshot(userSnapshot);
    }
    return null;
  }

  Future<void> addToPendingOrders(String userId, String orderId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.pendingOrderIdsField: FieldValue.arrayUnion([orderId])
    });
  }

  Future<void> addToCompletedOrders(String userId, String orderId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.completedOrderIdsField: FieldValue.arrayUnion([orderId]),
      FirestoreConstants.pendingOrderIdsField: FieldValue.arrayRemove([orderId])
    });
  }

  Future<void> addToFavorites(String userId, String shoeId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.favShoesField: FieldValue.arrayUnion([shoeId])
    });
  }

  Future<void> removeFromFavorites(String userId, String shoeId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.favShoesField: FieldValue.arrayRemove([shoeId])
    });
  }

  Future<void> addToCartShoes(String userId, String shoeId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.cartShoesField: FieldValue.arrayUnion([shoeId])
    });
  }

  Future<void> removeFromCartShoes(String userId, String shoeId) async {
    final userRef = _usersCollection.doc(userId);
    await userRef.update({
      FirestoreConstants.cartShoesField: FieldValue.arrayRemove([shoeId])
    });
  }
}
