import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String errorMsg = "";

  void login() {
    final user = userCtrl.text.trim();
    final pass = passCtrl.text.trim();

    // Simple local login for now
    if (user == "dilshan" && pass == "123") {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      setState(() => errorMsg = "Invalid username or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // -------------------------------------------------
              //            YOUR PHOTO (Profile Image)
              // -------------------------------------------------
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/images/myphoto.jpg"),
              ),

              SizedBox(height: 20),

              TextField(
                controller: userCtrl,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),

              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              if (errorMsg.isNotEmpty)
                Text(
                  errorMsg,
                  style: TextStyle(color: Colors.red),
                ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
