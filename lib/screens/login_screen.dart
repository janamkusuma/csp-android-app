import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '', password = '';
  String? error;

  Future<void> login() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('user');
    if (raw == null) {
      setState(() => error = 'No account found. Please register.');
      return;
    }
    final user = jsonDecode(raw);
    if (user['email'] == email && user['password'] == password) {
      await sp.setString('current_user', raw);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => error = 'Invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                SizedBox(height: 10),
                Center(child: Image.asset(kPlasticIcon, width: 80)),
                SizedBox(height: 8),
                Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkGreen)),
                SizedBox(height: 12),
                if (error != null) Container(padding: EdgeInsets.all(8), color: Colors.red[100], child: Text(error!)),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email or mobile', filled: true, fillColor: Colors.white),
                  validator: (v) => v!.isEmpty ? 'Enter email' : null,
                  onSaved: (v) => email = v!.trim(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white),
                  validator: (v) => v!.isEmpty ? 'Enter password' : null,
                  onSaved: (v) => password = v!.trim(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kDarkGreen, minimumSize: Size(double.infinity, 48)),
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      _form.currentState!.save();
                      login();
                    }
                  },
                  child: Text('LOGIN'),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
