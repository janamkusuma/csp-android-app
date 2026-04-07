import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  File? image;
  bool picking = false;

  // Function to pick image from camera
  Future pickImage() async {
    setState(() {
      picking = true;
    });

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image selected! (+20 points simulated)")),
      );

      // Return +20 points to BagSwapScreen
      Navigator.pop(context, {
        "points": 20,
        "image": picked.path,
      });
    }

    setState(() {
      picking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: Text(item["name"]), backgroundColor: Colors.green),
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(item["image"], height: 220, fit: BoxFit.cover),
            const SizedBox(height: 15),
            Text(item["name"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("₹${item["price"]}",
                style: const TextStyle(fontSize: 18, color: Colors.green)),
            const SizedBox(height: 15),
            const Text("Uses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...item["uses"].map<Widget>((u) => Text("• $u")),
            const SizedBox(height: 10),
            Text("Reuse: ${item["reuse"]}"),
            const SizedBox(height: 10),
            Text("Eco Impact: ${item["eco"]}", style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 20),

            // BUTTON 1: Use this product (+10 points)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "points": 10,
                  "image": null,
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("I will use this (+10 points)"),
            ),
            const SizedBox(height: 15),

            // IMAGE PREVIEW
            if (image != null) Image.file(image!, height: 150),

            // BUTTON 2: Pick proof image (+20 points)
            ElevatedButton(
              onPressed: picking ? null : pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: picking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload Proof (+20 points simulated)"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}