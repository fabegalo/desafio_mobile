//import 'package:permission_handler/permission_handler.dart';
import 'package:desafio_mobile/Componentes/DialogAlert.dart';
import 'package:desafio_mobile/Model/ModelSqlLite/Cruds/LoginCrud.dart'
    as Login;
import 'package:desafio_mobile/Telas/TelaDashboard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String _email = '';
  String _senha = '';

  bool _passwordVisible = false;

  TextEditingController userFieldControl = TextEditingController()..text = '';
  TextEditingController passFieldControl = TextEditingController()..text = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void _userChanges() {
    auth.userChanges().listen((User? user) {
      print(user?.email);
      if (user == null) {
        print('O usuário está desconectado no momento!');
      } else {
        setStateIfMounted(() {
          this.user = user;
        });
        print('O usuário está conectado!');

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/TelaDashboard', (Route<dynamic> route) => false);
        });
      }
    });
  }

  void _initializeFirebase() async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setStateIfMounted(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _userChanges();
  }

  @override
  Widget build(BuildContext context) {
    final loginField = TextFormField(
      controller: userFieldControl,
      obscureText: false,
      style: style,
      validator: validateLogin,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "E-mail",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      keyboardType: TextInputType.text,
      //maxLength: 10,
      onSaved: (String? val) {
        _email = val ?? '';
      },
      onChanged: (val) {
        setStateIfMounted(() {
          _email = val;
        });
      },
    );

    final passwordField = TextFormField(
      controller: passFieldControl,
      obscureText: !_passwordVisible,
      style: style,
      validator: validateSenha,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark),
            onPressed: () {
              setStateIfMounted(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      keyboardType: TextInputType.text,
      //maxLength: 15,
      onSaved: (String? val) {
        _senha = val!;
      },
      onChanged: (val) {
        setStateIfMounted(() {
          _senha = val;
        });
      },
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: logar,
        child: Text("Logar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: registrar,
        child: Text("Registrar-se",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    Widget _tela = new Container(
        child: new DecoratedBox(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    //color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 180,
                            child: Image.asset(
                                "assets/images/logo-bycoders.jpg",
                                fit: BoxFit.contain),
                          ),
                          SizedBox(height: 20.0),
                          loginField,
                          SizedBox(height: 20.0),
                          passwordField,
                          SizedBox(height: 20.0),
                          //_dropDownFilial(),
                          SizedBox(
                            height: 30.0,
                          ),
                          loginButton,
                          SizedBox(
                            height: 30.0,
                          ),
                          registerButton,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Center(
                child: Text('Desafio Mobile', style: TextStyle(fontSize: 30)))),
        body: _tela //: Center(child: _notPermission()),
        );
  }

  void logar() async {
    if (_validateInputs()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: _email, password: _senha);

        user = userCredential.user;

        Navigator.pop(context);

        if (user != null) {
          var datenow = new DateTime.now();

          String datetime = DateFormat('yyyy-MM-dd kk:mm:ss').format(datenow);

          Login.updateOrInsert(user?.uid, user?.email, datetime);

          Login.consultar();

          FirebaseAnalytics().logEvent(
              name: 'auth_login', parameters: {'user_email': user?.email});

          FirebaseAnalytics()
              .setUserProperty(name: "user_email", value: user?.email);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TelaDashboard()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          await showDialogAlert(
              context, 'Error', 'Nenhum usuario encontrado com esse email!');
          Navigator.pop(context);
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          await showDialogAlert(context, 'Error', 'Senha Incorreta!');
          Navigator.pop(context);
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  void registrar() async {
    if (_validateInputs()) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: _email, password: _senha);

        user = userCredential.user;

        FirebaseAnalytics().logEvent(
            name: 'auth_register', parameters: {'user_email': user?.email});

        await showDialogAlert(
            context, 'Conta', 'Conta cadastrada com sucesso!');

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          await showDialogAlert(
              context, 'Senha', 'A senha fornecida é muito fraca!');
          Navigator.pop(context);
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          await showDialogAlert(
              context, 'E-mail', 'A conta já existe para esse e-mail!');
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      setStateIfMounted(() {
        _autoValidate = AutovalidateMode.always;
      });
      return false;
    }
  }

  String? validateLogin(String? mat) {
    if (mat!.isEmpty) {
      return 'O campo E-mail é obrigatório!';
    } else {
      return null;
    }
  }

  String? validateSenha(String? senha) {
    if (senha!.isEmpty) {
      return 'O campo Senha é obrigatório!';
    } else {
      return null;
    }
  }

  setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
