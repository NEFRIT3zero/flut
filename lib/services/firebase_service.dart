import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut/models/product.dart';
import 'package:flut/models/user.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();

  factory FirebaseService() => instance;

  FirebaseService._internal();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(Product product) async {
    await firestore
        .collection('products')
        .doc(product.qrData)
        .set(product.toMap());
  }

  Future<List<Product>> downloadProducts() async {
    final snapshot = await firestore.collection('products').get();

    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }

  Future<void> uploadUser(User user) async {
    await firestore.collection('users').doc(user.login).set(user.toMap());
  }

  Future<List<User>> downloadUsers() async {
    final snapshot = await firestore.collection('users').get();

    return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
  }

  
}
