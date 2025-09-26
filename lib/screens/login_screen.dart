//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen ({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen > {

final _emailController = TextEditingController();
final _passController = TextEditingController();
final _formKey = GlobalKey<FormState>();




@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Entrar", style: TextStyle(color: Colors.white)),
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            "CRIAR CONTA",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ),
      ],
    ),
    body: ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text!.isEmpty || !text.contains("@")) {
                    return "E-mail inválido!";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(hintText: "Senha"),
                obscureText: true,
                validator: (text) {
                  if (text!.isEmpty || text.length < 6) {
                    return "Senha inválido!";
                  } else {
                    return null;
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: TextButton(
                    onPressed: () {
                      if(_emailController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const
                            SnackBar(content: Text("Insira seu e-mail para recuperação"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 3),

                            )
                        );

                      } else {
                        model.recoverPass(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Confira seu e-mail!"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: const Duration(seconds: 3),

                            )
                        );
                      }
                    },
                    child: const Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 44.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                    model.signIn(
                      email: _emailController.text,
                      pass: _passController.text,
                      onSuccess: _onSuccess,
                      onFail: _onFail,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(6.0),
                    ),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

void _onSuccess(){
  Navigator.of(context).pop();

}

void _onFail(){
  ScaffoldMessenger.of(context).showSnackBar(const
      SnackBar(content: Text("Falha ao Entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),

      )
  );

}
}

