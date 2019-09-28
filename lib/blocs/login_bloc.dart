import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenteloja/enums/login_state.dart';
import 'package:gerenteloja/validator/login_validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validatorEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatorPassword);

  Stream<LoginState> get outLoginState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (a, b) => true);

  StreamSubscription _streamSubscription;

  LoginBloc() {
    FirebaseAuth.instance.signOut();
    _streamSubscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  Function(String text) get changeEmail => _emailController.sink.add;

  Function(String text) get changePassword => _passwordController.sink.add;

  void onSubmit() {
    final email = _emailController.value; // Recupera o último dado da stream
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        return true; // O usuário está na lista de Administradores
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _streamSubscription.cancel();
    super.dispose();
  }
}
