import 'package:flutter/material.dart';
import 'package:ridesync/user.dart';

class loginscreen extends StatelessWidget {
  loginscreen({super.key});
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter your name';
                  }
                },
                decoration: InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter valid password';
                  }
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
