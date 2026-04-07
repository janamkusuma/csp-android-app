import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String filter = "Upcoming"; // Default filter
  String searchQuery = "";

  final List<Map<String, String>> events = [
    {
      "date": "Sat, May 18, 2026",
      "title": "Beach Clean-Up",
      "location": "Marina Beach",
      "type": "Upcoming",
    },
    {
      "date": "Fri, Jun 7, 2026",
      "title": "Zero-Waste Fair",
      "location": "Expo Center",
      "type": "Upcoming",
    },
    {
      "date": "Sun, Jun 30, 2026",
      "title": "Reusable Bag Workshop",
      "location": "Green Hall",
      "type": "Upcoming",
    },
    {
      "date": "Mon, Mar 5, 2025",
      "title": "Plastic Awareness Rally",
      "image": "assets/images/rally.jpg",
      "location": "City Park",
      "type": "Past",
    },
  ];

  // Function to open location in Google Maps
  Future<void> openMap(String location) async {
    final query = Uri.encodeComponent(location);
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open map")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = events.where((event) {
      final matchesType = event["type"] == filter;
      final matchesSearch =
      event["title"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Events",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Toggle (Upcoming / Past)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildToggleButton("Upcoming"),
                    _buildToggleButton("Past"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 12),

            // Event list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return _eventCard(event);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text) {
    final isSelected = filter == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filter = text;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventCard(Map<String, String> event) {
    return GestureDetector(
      onTap: () {
        openMap(event["location"]!); // Open map on tap
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(  // changed from Row to Column to show image below text
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Title
            Text(
              event["date"]!,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            SizedBox(height: 4),
            Text(
              event["title"]!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.black54),
                SizedBox(width: 4),
                Text(
                  event["location"]!,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],

            ),


            // ✅ Show image for Past events
            if (event["type"] == "Past" && event["image"] != null) ...[
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  event["image"]!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],


          ],
        ),
      ),
    );
  }
}