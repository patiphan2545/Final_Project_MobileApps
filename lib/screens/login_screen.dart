import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/main.dart';
import 'package:flutter_final/screens/create_account_screen.dart';
import 'package:flutter_final/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService _service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เข้าสู่ระบบ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(
                  "https://th.bing.com/th/id/OIP.3F0E92T9gZXZ7PUhjx5dwAHaHa?pid=ImgDet&rs=1"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
controller: _emailController,
decoration: const InputDecoration(
hintText: "E-mail",
prefixIcon: Icon(Icons.email_outlined),
),
),
const SizedBox(height: 10),
TextField(
controller: _passwordController,
obscureText: true,
decoration: const InputDecoration(
hintText: "Password",
prefixIcon: Icon(Icons.lock_outline),
),
),
const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  bool res = await _service.login(
                      _emailController.text, _passwordController.text);
                  if (res) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Logged in")));

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: 'ข้อมูลติดต่อลูกค้า')));
                  }
                },
                child: const Text("เข้าสู่ระบบ")),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateAccountScreen()));
              },
              child: GestureDetector(
  onTap: () {
    // ดำเนินการเมื่อกดที่ข้อความ
    Navigator.push(
context,
MaterialPageRoute(builder: (context) => CreateAccountScreen()),
    );
  },
  child: RichText(
    text: TextSpan(
      text: "ไม่มีบัญชี? ",
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      children: <TextSpan>[
        TextSpan(
          text: "สมัครบัญชี",
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        // หากต้องการเพิ่มข้อความเพิ่มเติม สามารถเพิ่ม TextSpan เพิ่มเติมได้ต่อไปนี้
        // TextSpan(
        //   text: "ข้อความเพิ่มเติม",
        //   style: TextStyle(
        //     color: Colors.grey,
        //   ),
        // ),
      ],
    ),
  ),
),

            )
          ],
        ),
      ),
    );
  }
}
