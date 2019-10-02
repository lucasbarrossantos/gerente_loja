import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/enums/login_state.dart';
import 'package:gerenteloja/screens/tabs/orders_tab.dart';
import 'package:gerenteloja/screens/tabs/products_tab.dart';
import 'package:gerenteloja/screens/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white))),
        child: BottomNavigationBar(
            unselectedItemColor: Colors.pinkAccent[100],
            showSelectedLabels: true,
            currentIndex: _page,
            onTap: (page) {
              _pageController.animateToPage(page,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Clientes')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text('Pedidos')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text('Produtos')),
            ]),
      ),
      body: SafeArea(
          child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _page = page;
                });
              },
              children: <Widget>[
            UsersTab(),
            OrdersTab(),
            ProductsTab(),
          ])),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    final _ordersBloc = BlocProvider.getBloc<OrdersBloc>();
    switch (_page) {
      case 0:
        return null;
        break;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: 'Concluídos Abaixo',
                labelStyle: TextStyle(fontSize: 14.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: 'Concluídos Acima',
                labelStyle: TextStyle(fontSize: 14.0),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
        );
    }

    return Container();
  }
}
