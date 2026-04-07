import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _current = 0;
  late Timer _timer;

  final List<Map<String, String>> slides = [
    {'title': 'Plastic Ban', 'image': 'assets/images/ban.png', 'desc': 'Say NO to single-use plastic.'},
    {'title': 'Harmful Effects', 'image': 'assets/images/harmful.png', 'desc': 'Plastic harms wildlife & soil.'},
    {'title': 'Save Nature', 'image': 'assets/images/nature.png', 'desc': 'Choose green — protect forests.'},
    {'title': 'Jute Bags', 'image': 'assets/images/jute.png', 'desc': 'Jute bags are reusable & eco-friendly.'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 60), (_) {
      int next = (_current + 1) % slides.length;
      _controller.animateToPage(next, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
    _controller.addListener(() {
      int page = _controller.page?.round() ?? 0;
      if (page != _current) setState(() => _current = page);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget slideItem(Map<String, String> s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(s['image']!, width: 200, height: 200),
        SizedBox(height: 20),
        Text(s['title']!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkGreen)),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(s['desc']!, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                itemBuilder: (_, i) => slideItem(slides[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (i) => Container(
                margin: EdgeInsets.all(4),
                width: _current == i ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _current == i ? kDarkGreen : Colors.white54,
                  borderRadius: BorderRadius.circular(8),
                ),
              )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: kDarkGreen,
                ),
                child: Text('Get Started', style: TextStyle(fontSize: 16)),
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  final currentUser = sp.getString('current_user');
                  if (currentUser != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
