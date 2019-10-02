import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/screens/home_screen.dart';
import 'package:gerenteloja/screens/login_screen.dart';

import 'blocs/login_bloc.dart';
import 'blocs/orders_bloc.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [
          Bloc((i) => LoginBloc()),
          Bloc((i) => UserBloc()),
          Bloc((i) => OrdersBloc()), 
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.pinkAccent,
          ),
          home: HomeScreen(),
        ));
  }
}
