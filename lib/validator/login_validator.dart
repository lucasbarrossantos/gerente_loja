import 'dart:async';

class LoginValidators {
  final validatorEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Insira um e-mail válido');
    }
  });

  final validatorPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length < 6) {
      sink.addError('Sua senha deve ter no mínimo 6 caracteres');
    } else if (password.isEmpty) {
      sink.addError('Insira sua senha');
    } else {
      sink.add(password);
    }
  });
}
