import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_susha/src/constants/firestore_keys.dart';

class SushaOrder {
  String orderId;
  final String userId;
  final String name;
  final String email;
  final String contact;
  final List<String> shoeIds;
  final Timestamp dateOfOrder;
  final String addressLine1;
  final String addressLine2;
  final String addressCity;
  final String addressCountry;
  final GeoPoint coordinates;
  final String deliveryCharges;
  final String shoesPrice;
  final String totalPrice;
  final String discount;
  final String deliveryStatus;
  final String paymentStatus;

  SushaOrder({
    required this.orderId,
    required this.userId,
    required this.name,
    required this.email,
    required this.contact,
    required this.shoeIds,
    required this.dateOfOrder,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressCity,
    required this.addressCountry,
    required this.coordinates,
    required this.deliveryCharges,
    required this.shoesPrice,
    required this.totalPrice,
    required this.discount,
    required this.deliveryStatus,
    required this.paymentStatus,
  });

  factory SushaOrder.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String,dynamic>;
    return SushaOrder(
      orderId: snapshot.id,
      userId: data[FirestoreConstants.userIdField] ?? '',
      name: data[FirestoreConstants.nameField] ?? '',
      email: data[FirestoreConstants.emailField] ?? '',
      contact: data[FirestoreConstants.contactField] ?? '',
      shoeIds: List<String>.from(data[FirestoreConstants.shoeIdsField] ?? []),
      dateOfOrder: data[FirestoreConstants.dateOfOrderField] ?? Timestamp(0, 0),
      addressLine1: data[FirestoreConstants.addressLine1Field] ?? '',
      addressLine2: data[FirestoreConstants.addressLine2Field] ?? '',
      addressCity: data[FirestoreConstants.addressCityField] ?? '',
      addressCountry: data[FirestoreConstants.addressCountryField] ?? '',
      coordinates: data[FirestoreConstants.coordinatesField] ?? GeoPoint(0, 0),
      deliveryCharges: data[FirestoreConstants.deliveryChargesField] ?? '',
      shoesPrice: data[FirestoreConstants.shoesPriceField] ?? '',
      totalPrice: data[FirestoreConstants.totalPriceField] ?? '',
      discount: data[FirestoreConstants.discountField] ?? '',
      deliveryStatus: data[FirestoreConstants.deliveryStatusField] ?? '',
      paymentStatus: data[FirestoreConstants.paymentStatusField] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.orderIdField: orderId,
      FirestoreConstants.userIdField: userId,
      FirestoreConstants.nameField: name,
      FirestoreConstants.emailField: email,
      FirestoreConstants.contactField: contact,
      FirestoreConstants.shoeIdsField: shoeIds,
      FirestoreConstants.dateOfOrderField: dateOfOrder,
      FirestoreConstants.addressLine1Field: addressLine1,
      FirestoreConstants.addressLine2Field: addressLine2,
      FirestoreConstants.addressCityField: addressCity,
      FirestoreConstants.addressCountryField: addressCountry,
      FirestoreConstants.coordinatesField: coordinates,
      FirestoreConstants.deliveryChargesField: deliveryCharges,
      FirestoreConstants.shoesPriceField: shoesPrice,
      FirestoreConstants.totalPriceField: totalPrice,
      FirestoreConstants.discountField: discount,
      FirestoreConstants.deliveryStatusField: deliveryStatus,
      FirestoreConstants.paymentStatusField: paymentStatus,
    };
  }
}
