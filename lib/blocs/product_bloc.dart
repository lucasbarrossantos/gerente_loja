import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;

  Stream<bool> get outLoading => _loadingController.stream;

  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['size'] = List.of(product.data['size']);

      _createdController.add(true);
    } else {
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'size': []
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String title) {
    unsavedData['title'] = title;
  }

  void saveDescription(String description) {
    unsavedData['description'] = description;
  }

  void savePrice(String price) {
    unsavedData['price'] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData['images'] = images;
  }

  void saveSizes(List sizes) {
    unsavedData['size'] = sizes;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference reference = await Firestore.instance
            .collection('products')
            .document(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)..remove('images'));
        await _uploadImages(reference.documentID);
        await reference.updateData(unsavedData);
      }
      _loadingController.add(false);
      _createdController.add(true);
      return true;
    } catch (error) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData['images'].length; i++) {
      if (unsavedData['images'][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId) // Documento pai
          .child(productId) // Documento filho
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(unsavedData['images'][i]);

      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      unsavedData['images'][i] = downloadUrl;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    super.dispose();
  }
}
