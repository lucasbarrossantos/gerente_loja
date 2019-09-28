import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/login_bloc.dart';
import 'package:gerenteloja/enums/login_state.dart';
import 'package:gerenteloja/widgets/input_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = BlocProvider.getBloc<LoginBloc>();

  @override
  void initState() {
    super.initState();

    _loginBloc.outLoginState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              (MaterialPageRoute(builder: (context) => HomeScreen())));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Erro'),
                    content: Text('Você não possui os previlégios necessários'),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: StreamBuilder<LoginState>(
            stream: _loginBloc.outLoginState,
            initialData: LoginState.LOADING,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  ));
                case LoginState.SUCCESS:
                case LoginState.FAIL:
                case LoginState.IDLE:
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(),
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Icon(
                                Icons.store_mall_directory,
                                color: Colors.pinkAccent,
                                size: 160.0,
                              ),
                              InputField(
                                icon: Icons.person_outline,
                                hint: 'Usuário',
                                obscure: false,
                                stream: _loginBloc.outEmail,
                                onChanged: _loginBloc.changeEmail,
                              ),
                              InputField(
                                icon: Icons.lock_outline,
                                hint: 'Senha',
                                obscure: true,
                                stream: _loginBloc.outPassword,
                                onChanged: _loginBloc.changePassword,
                              ),
                              SizedBox(height: 22.0),
                              StreamBuilder<bool>(
                                  stream: _loginBloc.outSubmitValid,
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                      height: 50.0,
                                      child: RaisedButton(
                                        color: Colors.pinkAccent,
                                        child: Text('Entrar'),
                                        onPressed: snapshot.hasData
                                            ? _loginBloc.onSubmit
                                            : null,
                                        textColor: Colors.white,
                                        disabledColor:
                                            Colors.pinkAccent.withAlpha(140),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                default:
                  return Container();
              }
            }));
  }
}
