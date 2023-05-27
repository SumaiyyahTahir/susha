class FirestoreConstants {
  // Collection names
  static const String usersCollection = 'users';
  static const String shoesCollection = 'shoes';
  static const String ordersCollection = 'orders';
  // User collection fields
  static const String idField = 'id';
  static const String pendingOrderIdsField = 'pendingOrderIds';
  static const String completedOrderIdsField = 'completedOrderIds';
  static const String cartShoesField = 'cartShoes';
  static const String favShoesField = 'favShoes';
  // Shoe collection fields
  static const String productIdField = 'productId';
  static const String imageUrlField = 'imageUrl';
  static const String modelField = 'model';
  static const String sizeField = 'size';
  static const String colorField = 'color';
  static const String descriptionField = 'description';
  static const String genderField = 'gender';
  static const String categoryField = 'category';
  static const String priceField = 'price';
  static const String isSoldField = 'isSold';
  // Order collection fields
  static const String orderIdField = 'orderId';
  static const String userIdField = 'userId';
  static const String nameField = 'name';
  static const String emailField = 'email';
  static const String contactField = 'contact';
  static const String shoeIdsField = 'shoeIds';
  static const String dateOfOrderField = 'dateOfOrder';
  static const String addressLine1Field = 'addressLine1';
  static const String addressLine2Field = 'addressLine2';
  static const String addressCityField = 'addressCity';
  static const String addressCountryField = 'addressCountry';
  static const String coordinatesField = 'coordinates';
  static const String deliveryChargesField = 'deliveryCharges';
  static const String shoesPriceField = 'shoesPrice';
  static const String totalPriceField = 'totalPrice';
  static const String discountField = 'discount';
  static const String deliveryStatusField = 'deliveryStatus';
  static const String paymentStatusField = 'paymentStatus';
}
