import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/screens/edit_item_screen.dart';
import 'package:flutter_final/screens/login_screen.dart';
import 'package:flutter_final/screens/new_item_screen.dart';
import 'package:flutter_final/services/auth_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); //เริ่มการทำงานของแอปพลิเคชัน
}

class MyApp extends StatelessWidget {
  //เป็น class ที่ extends จาก StatelessWidget
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //เป็นการสร้างหน้า home page ของแอปพลิเคชัน โดยใช้ MaterialApp เป็นส่วนหลักของการสร้างหน้าจอและตั้งค่าสีหลัก
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final_Project_MobileApps',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white70,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _service = AuthService();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _service.user;
    String displayEmail = "";
    if (currentUser != null && currentUser.email != null) {
      displayEmail = currentUser.email!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Row(
                children: [
  Icon(
  Icons.account_circle_outlined,
  size: 50, // กำหนดขนาดไอคอนเป็น 30 pixels
),
  SizedBox(width: 14),
  Text(
    "ยินดีต้อนรับ $displayEmail",
    style: TextStyle(
      color: Colors.white, // เปลี่ยนสีตัวหนังสือเป็นสีขาว
      fontSize: 13, // กำหนดขนาดตัวอักษร
      fontWeight: FontWeight.bold, // กำหนด font weight เป็น bold
    ),
  ),
],

              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.pinkAccent),
              title: const Text("ลงชื่อออก"),
              onTap: () {
                _service.logout(currentUser);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
      //สร้าง ListView จากข้อมูลที่ได้จาก collection "items" ใน Firestore ด้วย StreamBuilder
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: ((context, snapshot) {
          final dataDocuments = snapshot.data?.docs;
          if (dataDocuments == null) return const Text("No data");
          return ListView.builder(
            itemCount: dataDocuments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.star_border_purple500, color: Colors.pinkAccent),
                title: Text(dataDocuments[index]["name"].toString()),
                subtitle: Text(dataDocuments[index]["desc"].toString()),
                onTap: () => _editItemScreen(dataDocuments[index].id,
                    dataDocuments[index]["name"], dataDocuments[index]["desc"]),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewItem,
        tooltip: 'New Item',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //การสร้าง method _createNewItem() สำหรับการเพิ่มข้อมูลใหม่ในหน้า MyHomePage
  void _createNewItem() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewItemScreen()));
  }

  //สร้าง method _editItemScreen() สำหรับการแก้ไขข้อมูลที่เลือกแสดงในหน้าแอปพลิเคชัน
  _editItemScreen(String documentid, String itemName, String itemDesc) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditItemScreen(documentid, itemName, itemDesc)));
  }
}
