import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenteloja/blocs/product_bloc.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {
  final controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final _formKey = GlobalKey<FormState>();
  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16.0);
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text('Criar Produto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.remove), onPressed: () {}),
          IconButton(icon: Icon(Icons.save), onPressed: () {}),
        ],
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      initialValue: snapshot.data['title'],
                      style: _fieldStyle,
                      decoration: _buildDecoration('Título'),
                      onSaved: (text) {},
                      validator: (text) {},
                    ),
                    TextFormField(
                      initialValue: snapshot.data['description'],
                      style: _fieldStyle,
                      maxLines: 6,
                      decoration: _buildDecoration('Descrição'),
                      onSaved: (text) {},
                      validator: (text) {},
                    ),
                    TextFormField(
                      initialValue: formatMoney(snapshot.data['price']),
                      style: _fieldStyle,
                      decoration: _buildDecoration('Preço'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSaved: (text) {},
                      validator: (text) {},
                    ),
                  ],
                );
              })),
    );
  }

  String formatMoney(double value) {
    if (value != null) {
      controllerMasked.updateValue(value);
      return controllerMasked.text;
    } else
      return null;
  }
}
