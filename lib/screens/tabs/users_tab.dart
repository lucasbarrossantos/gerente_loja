import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/widgets/tiles/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

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
            child: StreamBuilder<List>(
                stream: _userBloc.outUser,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pinkAccent)));
                  } else if (snapshot.data.length == 0) {
                    return Center(
                        child: Text('Nenhuem usuário encontrado!',
                            style: TextStyle(color: Colors.pinkAccent)));
                  } else
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return UserTile(snapshot.data[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey);
                        },
                        itemCount: snapshot.data.length
                    );
                })),
      ],
    );
  }
}
