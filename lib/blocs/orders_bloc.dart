import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerenteloja/enums/login_state.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _orders = [];
  SortCriteria _criteria;

  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == oid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });

      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          int statusOfA = a.data['status'];
          int statusOfB = b.data['status'];

          if (statusOfA < statusOfB)
            return 1;
          else if (statusOfA > statusOfB)
            return -1;
          else
            return 0;
        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a, b) {
          int statusOfA = a.data['status'];
          int statusOfB = b.data['status'];

          if (statusOfA > statusOfB)
            return 1;
          else if (statusOfA < statusOfB)
            return -1;
          else
            return 0;
        });
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }
}
