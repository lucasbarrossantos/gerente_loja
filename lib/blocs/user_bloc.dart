import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();
  var controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');

  Stream<List> get outUser => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrder(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            // Se alterar apenas os dados do usuário
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrder(String uid) {
    _users[uid]['subscription'] = _firestore
        .collection('users')
        .document(uid)
        .collection('orders')
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;

      for (DocumentSnapshot doc in orders.documents) {
        DocumentSnapshot order = await _firestore
            .collection('orders')
            .document(doc.documentID)
            .get();

        if (order.data == null) continue;

        money += order.data['totalPrice'];
      }

      controllerMasked.updateValue(money);
      _users[uid].addAll({'money': controllerMasked.text, 'orders': numOrders});
      _usersController.add(_users.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());

    filteredUsers.retainWhere((user) {
      return user['name'].toUpperCase().contains(search.toUpperCase());
    });

    return filteredUsers;
  }

  Map<String, dynamic> getUsers(String uid) {
    return _users[uid];
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}
