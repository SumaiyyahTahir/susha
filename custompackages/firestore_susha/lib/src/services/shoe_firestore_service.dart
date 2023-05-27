// ignore_for_file: prefer_is_empty
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firestore_susha/src/constants/firestore_keys.dart';
import 'package:firestore_susha/src/models/shoe.dart';

class ShoeFirestoreService {
  final firestore.CollectionReference _shoesCollection = firestore
      .FirebaseFirestore.instance
      .collection(FirestoreConstants.shoesCollection);

  Future<List<Shoe>> getAvailableShoes() async {
    final firestore.QuerySnapshot querySnapshot = await _shoesCollection
        .where(FirestoreConstants.isSoldField, isEqualTo: false)
        .get();

    final List<Shoe> availableShoes = [];
    for (final firestore.DocumentSnapshot document in querySnapshot.docs) {
      final Shoe shoe = Shoe.fromSnapshot(document);
      availableShoes.add(shoe);
    }

    return availableShoes;
  }

  Future<List<Shoe>> getShoesByIds(List<String> shoeIds) async {
    if (shoeIds.isEmpty) return [];
    final firestore.QuerySnapshot querySnapshot = await _shoesCollection
        .where(firestore.FieldPath.documentId, whereIn: shoeIds)
        .get();

    final List<Shoe> shoes = [];
    if (querySnapshot.docs.length!=0) {
      for (final firestore.DocumentSnapshot document in querySnapshot.docs) {
        final Shoe shoe = Shoe.fromSnapshot(document);
        shoes.add(shoe);
      }
    }

    return shoes;
  }

  Future<void> markShoesAsSold(List<String> shoeIds) async {
    for (final String shoeId in shoeIds) {
      final firestore.DocumentReference shoeRef = _shoesCollection.doc(shoeId);
      await shoeRef.update({FirestoreConstants.isSoldField: true});
    }
  }

  Future<Shoe> getShoeById(String shoeId) async {
    final snapshot = await firestore.FirebaseFirestore.instance
        .collection('shoes')
        .doc(shoeId)
        .get();

    if (snapshot.exists) {
      return Shoe.fromSnapshot(snapshot);
    } else {
      throw Exception('Shoe not found');
    }
  }
}
