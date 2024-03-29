import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenteloja/blocs/product_bloc.dart';
import 'package:gerenteloja/validator/product_validator.dart';
import 'package:gerenteloja/widgets/images_widget.dart';
import 'package:gerenteloja/widgets/product_sizes.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text('Criando ou Editando Produto'),
        actions: <Widget>[
          StreamBuilder(
              stream: _productBloc.outCreated,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data) {
                  return StreamBuilder<bool>(
                      stream: _productBloc.outCreated,
                      initialData: false,
                      builder: (context, snapshot) {
                        return IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: snapshot.data
                                ? null
                                : () {
                                    _productBloc.deleteProduct();
                                    Navigator.of(context).pop();
                                  });
                      });
                } else
                  return Container();
              }),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: snapshot.data ? null : saveProduct);
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
              key: _formKey,
              child: StreamBuilder(
                  stream: _productBloc.outData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        Text(
                          'Imagens',
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                        ImagesWidget(
                          context: context,
                          initialValue: snapshot.data['images'],
                          onSaved: _productBloc.saveImages,
                          validator: validateImages,
                        ),
                        TextFormField(
                          initialValue: snapshot.data['title'],
                          style: _fieldStyle,
                          decoration: _buildDecoration('Título'),
                          onSaved: _productBloc.saveTitle,
                          validator: validateTitle,
                        ),
                        TextFormField(
                          initialValue: snapshot.data['description'],
                          style: _fieldStyle,
                          maxLines: 6,
                          decoration: _buildDecoration('Descrição'),
                          onSaved: _productBloc.saveDescription,
                          validator: validateDescription,
                        ),
                        TextFormField(
                          initialValue: formatMoney(
                              snapshot.data['price'] != null
                                  ? snapshot.data['price'] + 0.0
                                  : 0.0),
                          style: _fieldStyle,
                          decoration: _buildDecoration('Preço'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onSaved: _productBloc.savePrice,
                          validator: validatePrice,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Tamanhos',
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                        ProductSize(
                          context: context,
                          initialValue: snapshot.data['size'],
                          onSaved: _productBloc.saveSizes,
                          validator: validatorSizes,
                        ),
                      ],
                    );
                  })),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              })
        ],
      ),
    );
  }

  String formatMoney(double value) {
    if (value != null) {
      controllerMasked.updateValue(value);
      return controllerMasked.text;
    } else
      return null;
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      /*
                    Se os campos estiverem ok, então,
                    Chama o onSaved de cada componente
                   */
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Salvando produto...',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      bool success = await _productBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? 'Produto salvo' : 'Erro ao salvar produto.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }
}
