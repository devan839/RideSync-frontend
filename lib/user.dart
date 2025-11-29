import 'package:flutter/material.dart';
import 'package:ridesync/login.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
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
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your contact number';
                    }
                  },

                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your valid email';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
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
                    hintText: "Enter Password ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: cpassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter valid password';
                    } else if (value != password) {
                      return "Password does not match";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginscreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
