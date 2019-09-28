import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Title', style: textStyle),
      subtitle: Text('Subtitle', style: textStyle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 16.0),
          Text('Pedidos: 0', style: textStyle),
          Text('Gasto: 0', style: textStyle),
        ],
      ),
    );
  }
}
