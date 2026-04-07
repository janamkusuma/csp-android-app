import 'package:flutter/material.dart';
import '../constants.dart';

class EcoCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  EcoCard({required this.title, required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(12),
      child: Row(children: [
        CircleAvatar(child: Icon(icon, color: kPrimaryGreen), backgroundColor: Colors.white),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(body),
        ])),
      ]),
    );
  }
}
