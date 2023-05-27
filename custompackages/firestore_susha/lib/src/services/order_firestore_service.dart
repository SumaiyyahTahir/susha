import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/src/constants/firestore_keys.dart';
import 'package:firestore_susha/src/models/order.dart';
import 'package:firestore_susha/src/services/user_firestore_service.dart';

class OrderFirestoreService {
  final CollectionReference _ordersCollection = FirebaseFirestore.instance
      .collection(FirestoreConstants.ordersCollection);
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(FirestoreConstants.usersCollection);
  final CollectionReference _shoesCollection =
      FirebaseFirestore.instance.collection(FirestoreConstants.shoesCollection);

  Future<SushaOrder> placeOrder(SushaOrder order) async {
    try {
      // Add the order to the 'orders' collection with an auto-generated document ID
      final orderDocRef = await _ordersCollection.add(order.toMap());
      final orderId = orderDocRef.id;
      order.orderId = orderDocRef.id;

      // Update the user's pendingOrderIds list
      final userDocRef = _usersCollection.doc(order.userId);
      final userSnapshot = await userDocRef.get();
      final userOrderData = userSnapshot.data() as Map;
      final List<String> pendingOrderIds = List<String>.from(
          userOrderData[FirestoreConstants.pendingOrderIdsField] ?? []);
      pendingOrderIds.add(orderId);
      await userDocRef
          .update({FirestoreConstants.pendingOrderIdsField: pendingOrderIds});

      QuerySnapshot allUsersSnapshot = await _usersCollection.get();

      // Update the 'isSold' property of each shoe in the order
      for (final shoeId in order.shoeIds) {
        final shoeDocRef = _shoesCollection.doc(shoeId);
        await shoeDocRef.update({FirestoreConstants.isSoldField: true});

        for (final DocumentSnapshot document in allUsersSnapshot.docs) {
          await UserFirestoreService().removeFromCartShoes(document.id, shoeId);
          await UserFirestoreService().removeFromFavorites(document.id, shoeId);
        }
      }

      return order;
    } catch (error) {
      // Handle error
      print('Error placing order: $error');
      rethrow;
    }
  }

  Future<List<SushaOrder>> getOrders(List<String> orderIds) async {
    try {
      final List<SushaOrder> orders = [];

      // Fetch the orders from the 'orders' collection based on the given order IDs
      final orderDocs = await _ordersCollection
          .where(FieldPath.documentId, whereIn: orderIds)
          .get();

      // Convert each order document to an Order object and add it to the list
      for (final doc in orderDocs.docs) {
        final order = SushaOrder.fromSnapshot(doc);
        orders.add(order);
      }

      return orders;
    } catch (error) {
      // Handle error
      print('Error retrieving orders: $error');
      rethrow;
    }
  }

  Future<void> completeOrder(String orderId, String userId) async {
    try {
      // Update the order with the new delivery status
      final orderDocRef = _ordersCollection.doc(orderId);
      await orderDocRef
          .update({FirestoreConstants.deliveryStatusField: 'complete'});

      // Remove the order ID from the user's pendingOrderIds list and add it to completedOrderIds
      final userDocRef = _usersCollection.doc(userId);
      final userSnapshot = await userDocRef.get();
      final userData = userSnapshot.data() as Map;
      final List<String> pendingOrderIds = List<String>.from(
          userData[FirestoreConstants.pendingOrderIdsField] ?? []);
      final List<String> completedOrderIds = List<String>.from(
          userData[FirestoreConstants.completedOrderIdsField] ?? []);
      pendingOrderIds.remove(orderId);
      completedOrderIds.add(orderId);
      await userDocRef.update({
        FirestoreConstants.pendingOrderIdsField: pendingOrderIds,
        FirestoreConstants.completedOrderIdsField: completedOrderIds,
      });
    } catch (error) {
      // Handle error
      print('Error completing order: $error');
      rethrow;
    }
  }
}
