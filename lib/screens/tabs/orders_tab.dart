import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/widgets/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
          initialData: [],
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return OrderTile(snapshot.data[index]);
                  });
            } else if (snapshot.data.length == 0) {
              return Center(
                  child: Text('Nenhum pedido encontrado.',
                      style: TextStyle(color: Colors.pinkAccent)));
            } else {
              return Center(
                  child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              ));
            }
          }),
    );
  }
}
