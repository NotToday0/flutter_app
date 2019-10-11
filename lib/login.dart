import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password ;
  final formKey = new GlobalKey<FormState>();

  validateFun(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
      return false;
  }
  void  submit() async{
    if (validateFun()) {
      try{
        AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print('Inside  Try $user');
      }catch(e){
        print('Error $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value.isEmpty ? "Emal cant be empty" : null,
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) => value.isEmpty ? "Emal cant be empty" : null,
                  onSaved: (value) => _password = value,
                ),
                RaisedButton(
                    onPressed: submit,
                    child: Text("Login"),
                )
              ]
            ),
          ),
      ),
    );
  }
}
