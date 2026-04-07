import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyStoresScreen extends StatefulWidget {
  @override
  _NearbyStoresScreenState createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends State<NearbyStoresScreen> {
  GoogleMapController? mapController;

  final List<Map<String, dynamic>> stores = [
    {
      "name": "EcoMart",
      "address": "123 Green Street, Guntur",
      "lat": 16.3067,
      "lng": 80.4365,
      "open": "08:00",
      "close": "20:00",
    },
    {
      "name": "Nature's Basket",
      "address": "456 Eco Avenue, Guntur",
      "lat": 16.3080,
      "lng": 80.4410,
      "open": "10:00",
      "close": "18:00",
    },
    {
      "name": "Planet Store",
      "address": "789 Reuse Road, Guntur",
      "lat": 16.3095,
      "lng": 80.4380,
      "open": "09:00",
      "close": "17:00",
    },
  ];

  // Check if store is open now
  bool isOpenNow(String open, String close) {
    final now = DateTime.now();
    final openParts = open.split(':');
    final closeParts = close.split(':');
    final openTime = DateTime(
        now.year, now.month, now.day, int.parse(openParts[0]), int.parse(openParts[1]));
    final closeTime = DateTime(
        now.year, now.month, now.day, int.parse(closeParts[0]), int.parse(closeParts[1]));
    return now.isAfter(openTime) && now.isBefore(closeTime);
  }

  // Create store markers
  Set<Marker> _createMarkers() {
    return stores.map((store) {
      bool open = isOpenNow(store["open"], store["close"]);
      return Marker(
        markerId: MarkerId(store["name"]),
        position: LatLng(store["lat"], store["lng"]),
        infoWindow: InfoWindow(
          title: store["name"],
          snippet: "${store["address"]} ${open ? "(Open Now)" : "(Closed)"}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          open ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Open store in Google Maps
  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Center map on the first store
    final initialLatLng = LatLng(stores[0]["lat"], stores[0]["lng"]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Stores"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Map
          Container(
            height: 300,
            margin: EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                CameraPosition(target: initialLatLng, zoom: 14),
                markers: _createMarkers(),
                zoomControlsEnabled: false,
              ),
            ),
          ),

          // Store list
          Expanded(
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                final open = isOpenNow(store["open"], store["close"]);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      Icons.store,
                      color: open ? Colors.green : Colors.red,
                    ),
                    title: Text(store["name"]),
                    subtitle: Text(
                        "${store["address"]} ${open ? '(Open Now)' : '(Closed)'}"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openMaps(store["lat"], store["lng"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}