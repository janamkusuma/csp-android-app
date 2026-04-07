import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '', email = '';
  final _form = GlobalKey<FormState>();

  Future<void> loadUser() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('current_user') ?? sp.getString('user');
    if (raw != null) {
      final u = jsonDecode(raw);
      setState(() {
        name = u['name'] ?? '';
        email = u['email'] ?? '';
      });
    }
  }

  Future<void> saveProfile() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('current_user') ?? sp.getString('user');
    if (raw != null) {
      final u = jsonDecode(raw);
      u['name'] = name;
      u['email'] = email;
      final encoded = jsonEncode(u);
      await sp.setString('user', encoded);
      await sp.setString('current_user', encoded);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved')));
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      appBar: AppBar(backgroundColor: kPrimaryGreen, elevation: 0, iconTheme: IconThemeData(color: kDarkGreen)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(children: [
            CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/nature.png')),
            SizedBox(height: 12),
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(labelText: 'Name', filled: true, fillColor: Colors.white),
              onSaved: (v) => name = v!.trim(),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: email,
              decoration: InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white),
              onSaved: (v) => email = v!.trim(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kDarkGreen, minimumSize: Size(double.infinity, 48)),
              onPressed: saveProfile,
              child: Text('Save'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 48)),
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                await sp.remove('current_user');
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Log Out'),
            ),
          ]),
        ),
      ),
    );
  }
}
