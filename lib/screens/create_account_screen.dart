import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final/screens/login_screen.dart';
import 'package:flutter_final/services/auth_service.dart';

class CreateAccountScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService _service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("สมัครสมาชิก"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            TextField(
  controller: _emailController,
  decoration: InputDecoration(
    hintText: "E-mail",
    prefixIcon: Icon(Icons.email_outlined),
  ),
),
SizedBox(
  height: 10,
),
TextField(
  controller: _passwordController,
  obscureText: true,
  decoration: InputDecoration(
    hintText: "Password",
    prefixIcon: Icon(Icons.lock_outline),
  ),
),
SizedBox(
  height: 20,
),
            ElevatedButton(
                onPressed: () async {
                  bool res = await _service.register(
                      _emailController.text, _passwordController.text);
                  if (res) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Account created successfully.")));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                },
                child: const Text("สมัครสมาชิก"))
          ],
        ),
      ),
    );
  }
}
