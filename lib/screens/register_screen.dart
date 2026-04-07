import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String name = '', email = '';

  Future<void> register() async {
    final sp = await SharedPreferences.getInstance();
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      final user = {
        'name': name,
        'email': email,
        'password': _passwordController.text.trim(),
        'points': 75
      };
      await sp.setString('user', jsonEncode(user));

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text('Account Registered Successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              SizedBox(height: 10),
              Center(child: Image.asset(kPlasticIcon, width: 80)),
              SizedBox(height: 10),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Name', filled: true, fillColor: Colors.white),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
                onSaved: (v) => name = v!.trim(),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email', filled: true, fillColor: Colors.white),
                validator: (v) => v!.contains('@') ? null : 'Enter valid email',
                onSaved: (v) => email = v!.trim(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password', filled: true, fillColor: Colors.white),
                validator: (v) => v!.length >= 6 ? null : 'Min 6 chars',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white),
                validator: (v) => v == _passwordController.text
                    ? null
                    : 'Passwords do not match',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen,
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: register,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
