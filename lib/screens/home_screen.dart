import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../widgets/eco_card.dart';
import 'proof_gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'User';
  int points = 0;

  Future<void> loadUser() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('current_user') ?? sp.getString('user');
    if (raw != null) {
      final u = jsonDecode(raw);
      setState(() {
        name = u['name'] ?? 'User';
        points = u['points'] ?? 75;
      });
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
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Row(children: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/nature.png')),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hi $name', style: TextStyle(color: kDarkGreen, fontWeight: FontWeight.bold)),

          ])
        ]),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person, color: kDarkGreen))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EcoCard(
              title: 'Eco Tip',
              body: 'Bring your own reusable bag when shopping.',
              icon: Icons.lightbulb,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: kDarkGreen),
              onPressed: () => Navigator.pushNamed(context, '/track'),
              child: Text('TRACK USAGE'),

            ),

            SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true, // 👈 IMPORTANT
              physics: NeverScrollableScrollPhysics(), // 👈 IMPORTANT
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _tile('Awareness', Icons.info, () => Navigator.pushNamed(context, '/awareness')),
                _tile('Eco Products', Icons.swap_horiz, () => Navigator.pushNamed(context, '/bag swap')),
                _tile('Events', Icons.event, () => Navigator.pushNamed(context, '/events')),
                _tile('Nearby Stores', Icons.store, () => Navigator.pushNamed(context, '/stores')),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/proofs');
              },
              icon: const Icon(Icons.photo_library),
              label: const Text("View Proof Gallery"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(String t, IconData i, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(i, size: 36, color: kDarkGreen),
          SizedBox(height: 8),
          Text(t, style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
