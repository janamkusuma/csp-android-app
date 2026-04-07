import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class TrackScreen extends StatefulWidget {
  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  int todayPoints = 0;
  int streak = 0;

  List<bool> checked = List.generate(6, (_) => false);

  List<String> activities = [
    "Used reusable bag",
    "Avoided plastic bottle",
    "Used steel bottle",
    "Used cloth/jute bag",
    "Avoided plastic straw",
    "Used reusable container"
  ];

  List<FlSpot> weeklyData = [];

  @override
  void initState() {
    super.initState();

    loadData();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData(); // refresh every time screen opens
  }



  // ✅ LOAD DATA (FIXED)
  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();

    List<int> list = List<int>.from(
        jsonDecode(sp.getString('weeklyPoints') ?? "[0,0,0,0,0,0,0]")
    );

    setState(() {
      streak = sp.getInt('streak') ?? 0;
      weeklyData = List.generate(
          7, (i) => FlSpot(i.toDouble(), list[i].toDouble()));
    });
  }

  // ✅ UPDATE STREAK
  Future<void> updateStreak() async {
    final sp = await SharedPreferences.getInstance();

    String today = DateTime.now().toString().substring(0, 10);
    String? lastDate = sp.getString('lastDate');

    int currentStreak = sp.getInt('streak') ?? 0;

    if (lastDate == null) {
      currentStreak = 1;
    } else {
      DateTime last = DateTime.parse(lastDate);
      DateTime now = DateTime.now();

      int diff = now.difference(last).inDays;

      if (diff == 1) {
        currentStreak += 1;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    await sp.setInt('streak', currentStreak);
    await sp.setString('lastDate', today);

    setState(() {
      streak = currentStreak;
    });
  }

  // ✅ SAVE TODAY POINTS (ADD NOT REPLACE 🔥)
  Future<void> saveTodayPoints(int points) async {
    final sp = await SharedPreferences.getInstance();

    List<int> list = List<int>.from(
        jsonDecode(sp.getString('weeklyPoints') ?? "[0,0,0,0,0,0,0]")
    );

    int todayIndex = DateTime.now().weekday - 1;

    list[todayIndex] = list[todayIndex] + points;

    await sp.setString('weeklyPoints', jsonEncode(list));
  }

  // ✅ SUBMIT
  Future<void> submitUsage() async {
    int points = 0;

    for (int i = 0; i < checked.length; i++) {
      if (checked[i]) points += 10;
    }

    setState(() {
      todayPoints += points;
    });

    await updateStreak();
    await saveTodayPoints(points);

    // ✅ UPDATE GLOBAL POINTS
    final sp = await SharedPreferences.getInstance();
    int total = sp.getInt('ecoPoints') ?? 0;
    total += points;
    await sp.setInt('ecoPoints', total);

    // ✅ REFRESH GRAPH IMMEDIATELY 🔥
    await loadData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Great! +$points points earned 🎉")),
    );
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Track Usage',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkGreen)),

            SizedBox(height: 10),

            // 🔥 STREAK
            Text("🔥 Streak: $streak days",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),

            SizedBox(height: 10),

            // 📊 GRAPH
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.all(12),
              child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData,
                    isCurved: true,
                    barWidth: 3,
                  )
                ],
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                      const days = ['M','T','W','T','F','S','S'];
                      return Text(days[v.toInt()]);
                    }),
                  ),
                ),
              )),
            ),

            SizedBox(height: 12),

            // ✅ CHECKBOXES
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(activities[index]),
                    value: checked[index],
                    onChanged: (val) {
                      setState(() {
                        checked[index] = val!;
                      });
                    },
                  );
                },
              ),
            ),

            // 📊 POINTS
            Text("Today's Points: $todayPoints",
                style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // 🚀 SUBMIT BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen,
                  minimumSize: Size(double.infinity, 50)),
              onPressed: submitUsage,
              child: Text("Submit Today's Usage"),
            ),
          ],
        ),
      ),
    );
  }
}