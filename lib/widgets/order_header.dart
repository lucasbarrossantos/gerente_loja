import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  final controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();
    final _user = _userBloc.getUsers(order.data['clientId']);
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${_user['name']}'),
                Text('${_user['addres']}'),
          ],
        )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Produtos: R\$${formaterMoney(order.data['productsPrices'])}',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Text('Total: R\$${formaterMoney(order.data['totalPrice'])}',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  String formaterMoney(double value) {
    controllerMasked.updateValue(value);
    return controllerMasked.text;
  }
}
