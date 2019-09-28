import 'package:flutter/material.dart';
import 'package:gerenteloja/widgets/tiles/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search, color: Colors.white),
                border: InputBorder.none),
          ),
        ),
        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return UserTile();
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey);
                },
                itemCount: 5)),
      ],
    );
  }
}
