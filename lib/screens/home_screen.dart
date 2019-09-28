import 'package:flutter/material.dart';
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
                Container(color: Colors.grey),
                Container(color: Colors.white70),
              ])
      ),
    );
  }
}
