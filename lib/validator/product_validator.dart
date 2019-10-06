import 'package:flutter_masked_text/flutter_masked_text.dart';

class ProductValidator {
  final controllerMasked = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');

  String validateImages(List images) {
    if (images.isEmpty) {
      return 'Adicione uma imagem ao produto.';
    } else
      return null;
  }

  String validateTitle(String text) {
    if (text.isEmpty) {
      return 'Preencha o título do produto!';
    } else
      return null;
  }

  String validateDescription(String text) {
    if (text.isEmpty) {
      return 'Preencha a descrição do produto!';
    } else
      return null;
  }

  String validatePrice(String text) {
    double price = double.tryParse(text);
    if (price != null) {
      try {
        controllerMasked.updateValue(price);
      } catch (e) {
        return 'Preço inválido';
      }
    }

    return null;
  }

  String validatorSizes(List sizes) {
    if (sizes.isEmpty)
      return 'Adicione um tamanho';
    else
      return null;
  }
}
