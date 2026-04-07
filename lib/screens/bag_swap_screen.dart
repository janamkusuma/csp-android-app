import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BagSwapScreen extends StatefulWidget {
  const BagSwapScreen({super.key});

  @override
  State<BagSwapScreen> createState() => _BagSwapScreenState();
}

class _BagSwapScreenState extends State<BagSwapScreen> {
  int ecoPoints = 0;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  Future<void> loadPoints() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      ecoPoints = sp.getInt('ecoPoints') ?? 0;
    });
  }

  // ✅ UPDATE GRAPH DATA ALSO (VERY IMPORTANT 🔥)
  Future<void> updateWeeklyGraph(int addedPoints) async {
    final sp = await SharedPreferences.getInstance();

    List<int> list = List<int>.from(
        jsonDecode(sp.getString('weeklyPoints') ?? "[0,0,0,0,0,0,0]")
    );

    int todayIndex = DateTime.now().weekday - 1;

    list[todayIndex] = list[todayIndex] + addedPoints;

    await sp.setString('weeklyPoints', jsonEncode(list));
  }

  Future<void> uploadProof(String productName, String imagePath) async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('proofs');

    List<Map<String, dynamic>> proofs = [];

    if (data != null) {
      proofs = List<Map<String, dynamic>>.from(jsonDecode(data));
    }

    proofs.add({
      "product": productName,
      "image": imagePath,
      "likes": 0,
      "comments": []
    });

    await sp.setString('proofs', jsonEncode(proofs));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Proof saved successfully")),
    );
  }



  final List<Map<String, dynamic>> items = [


      {
        "name": "Cloth Bag",
        "price": 100,
        "image": "assets/images/green_bag.jpg",
        "desc": "Lightweight reusable bag for daily shopping.",
        "uses": ["Vegetables", "Fruits", "Grocery"],
        "reuse": "50+ times",
        "eco": "Saves 50 plastic bags"
      },
      {
        "name": "Jute Bag",
        "price": 200,
        "image": "assets/images/leaf_bag.jpg",
        "desc": "Strong, biodegradable bag for heavier items.",
        "uses": ["Heavy items", "Rice bags"],
        "reuse": "100+ times",
        "eco": "Reduces plastic waste"
      },
      {
        "name": "Tote Bag",
        "price": 150,
        "image": "assets/images/tote_bag.jpg",
        "desc": "Stylish bag for shopping or casual use.",
        "uses": ["Shopping", "Books", "Daily carry"],
        "reuse": "100+ times",
        "eco": "Reduces plastic bag use"
      },
      {
        "name": "Mesh Bag",
        "price": 120,
        "image": "assets/images/mesh_bag.jpg",
        "desc": "Breathable bag for fruits and vegetables.",
        "uses": ["Vegetables", "Fruits", "Laundry"],
        "reuse": "50+ times",
        "eco": "Avoids plastic produce bags"
      },
      {
        "name": "Steel Bottle",
        "price": 250,
        "image": "assets/images/steel_bottle.jpg",
        "desc": "Durable bottle for daily hydration.",
        "uses": ["Water", "Juice", "Daily use"],
        "reuse": "Years",
        "eco": "Avoids plastic bottles"
      },
      {
        "name": "Wooden Spoon",
        "price": 50,
        "image": "assets/images/wooden_spoon.jpg",
        "desc": "Eco-friendly alternative to plastic spoons.",
        "uses": ["Cooking", "Serving"],
        "reuse": "Years",
        "eco": "Reduces plastic cutlery"
      },
      {
        "name": "Bamboo Toothbrush",
        "price": 80,
        "image": "assets/images/bamboo_toothbrush.jpg",
        "desc": "Sustainable toothbrush made of bamboo.",
        "uses": ["Brushing teeth"],
        "reuse": "Months",
        "eco": "Reduces plastic toothbrush waste"
      },
      {
        "name": "Cotton Produce Bags",
        "price": 120,
        "image": "assets/images/cotton_bag.jpg",
        "desc": "Reusable bags for fruits and vegetables.",
        "uses": ["Vegetables", "Fruits", "Grains"],
        "reuse": "50+ times",
        "eco": "Avoids plastic produce bags"
      },
      {
        "name": "Glass Jar",
        "price": 150,
        "image": "assets/images/glass_jar.jpg",
        "desc": "Store dry food or liquids sustainably.",
        "uses": ["Spices", "Grains", "Liquids"],
        "reuse": "Years",
        "eco": "Reduces plastic containers"
      },
      {
        "name": "Reusable Straw",
        "price": 40,
        "image": "assets/images/metal_straw.jpg",
        "desc": "Metal straw to replace single-use plastic straws.",
        "uses": ["Cold drinks", "Juice", "Smoothies"],
        "reuse": "Years",
        "eco": "Saves hundreds of plastic straws"
      },
      {
        "name": "Bamboo Cutlery Set",
        "price": 100,
        "image": "assets/images/bamboo_cutlery.jpg",
        "desc": "Portable cutlery set for meals on-the-go.",
        "uses": ["Lunch", "Travel", "Picnics"],
        "reuse": "Years",
        "eco": "Reduces single-use plastic forks & spoons"
      },
      {
        "name": "Reusable Coffee Cup",
        "price": 180,
        "image": "assets/images/reusable_cup.jpg",
        "desc": "Eco-friendly cup for daily coffee or tea.",
        "uses": ["Coffee", "Tea", "Cold drinks"],
        "reuse": "Years",
        "eco": "Reduces disposable cups"
      },
      {
        "name": "Beeswax Wrap",
        "price": 220,
        "image": "assets/images/beeswax_wrap.jpg",
        "desc": "Wrap food naturally without plastic.",
        "uses": ["Sandwiches", "Vegetables", "Fruits"],
        "reuse": "Months",
        "eco": "Replaces cling film"
      },
      {
        "name": "Reusable Snack Bag",
        "price": 90,
        "image": "assets/images/snack_bag.jpg",
        "desc": "Keep snacks fresh without plastic.",
        "uses": ["Chips", "Fruits", "Nuts"],
        "reuse": "50+ times",
        "eco": "Reduces plastic snack bags"
      },
      {
        "name": "Compost Bin",
        "price": 300,
        "image": "assets/images/compost_bin.jpg",
        "desc": "Turn food waste into compost for garden.",
        "uses": ["Kitchen waste", "Vegetable peels"],
        "reuse": "Years",
        "eco": "Reduces landfill waste"
      },
      {
        "name": "Reusable Lunch Box",
        "price": 200,
        "image": "assets/images/lunch_box.jpg",
        "desc": "Eco-friendly lunch box for school/work.",
        "uses": ["Meals", "Snacks"],
        "reuse": "Years",
        "eco": "Avoids plastic containers"
      },
      {
        "name": "Cloth Napkin",
        "price": 60,
        "image": "assets/images/cloth_napkin.jpg",
        "desc": "Reusable cloth napkin for dining.",
        "uses": ["Meals", "Picnics"],
        "reuse": "Years",
        "eco": "Replaces disposable paper napkins"
      },
      {
        "name": "Reusable Water Pouch",
        "price": 120,
        "image": "assets/images/water_pouch.jpg",
        "desc": "Carry water in sustainable pouches.",
        "uses": ["Water", "Juice"],
        "reuse": "50+ times",
        "eco": "Reduces bottled water use"
      },
      {
        "name": "Metal Lunch Box",
        "price": 250,
        "image": "assets/images/metal_lunchbox.jpg",
        "desc": "Durable metal box for meals.",
        "uses": ["Lunch", "Snacks", "Travel"],
        "reuse": "Years",
        "eco": "Avoids plastic boxes"
      },
      {
        "name": "Bamboo Plate Set",
        "price": 180,
        "image": "assets/images/bamboo_plate.jpg",
        "desc": "Eco-friendly plates for meals.",
        "uses": ["Lunch", "Dinner", "Snacks"],
        "reuse": "Years",
        "eco": "Reduces disposable plates"
      },
      {
        "name": "Glass Bottle",
        "price": 220,
        "image": "assets/images/glass_bottle.jpg",
        "desc": "Durable bottle for liquids.",
        "uses": ["Water", "Juice", "Milk"],
        "reuse": "Years",
        "eco": "Reduces single-use plastic bottles"
      },
      {
        "name": "Bamboo Toothpaste Tube",
        "price": 150,
        "image": "assets/images/bamboo_toothpaste.jpg",
        "desc": "Natural toothpaste in bamboo packaging.",
        "uses": ["Brushing teeth"],
        "reuse": "Months",
        "eco": "Reduces plastic toothpaste tubes"
      },



  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) {
      return item["name"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Eco Products (Points: $ecoPoints)"),
      ),
      backgroundColor: Colors.green.shade100,
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📦 GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredItems.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = filteredItems[index];

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(item: item),
                      ),
                    );

                    if (result != null) {
                      int earned = (result["points"] ?? 0) as int;

                      // ✅ UPDATE POINTS
                      setState(() {
                        ecoPoints += earned;
                      });

                      // ✅ SAVE TOTAL POINTS
                      final spPoints = await SharedPreferences.getInstance();
                      await spPoints.setInt('ecoPoints', ecoPoints);

                      // ✅ UPDATE GRAPH ALSO 🔥🔥
                      await updateWeeklyGraph(earned);

                      // ✅ SAVE PROOF
                      if (result["image"] != null) {
                        final sp = await SharedPreferences.getInstance();
                        final data = sp.getString('proofs');

                        List<Map<String, dynamic>> proofs = [];

                        if (data != null) {
                          proofs = List<Map<String, dynamic>>.from(jsonDecode(data));
                        }

                        proofs.add({
                          "product": item["name"],
                          "image": result["image"],
                          "likes": 0,
                          "comments": []
                        });

                        await sp.setString('proofs', jsonEncode(proofs));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Proof saved successfully")),
                        );
                      }
                    }
                  },

                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(12),
                            child: Image.asset(
                              item["image"],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(item["name"],
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold)),
                              Text("₹${item["price"]}"),
                            ],
                          ),
                        )
                      ],
                    ),
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