import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProofGalleryScreen extends StatefulWidget {
  const ProofGalleryScreen({super.key});

  @override
  State<ProofGalleryScreen> createState() => _ProofGalleryScreenState();
}

class _ProofGalleryScreenState extends State<ProofGalleryScreen> {
  List<Map<String, dynamic>> proofs = [];

  @override
  void initState() {
    super.initState();
    loadProofs();
  }

  // ✅ LOAD PROOFS
  Future<void> loadProofs() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('proofs');

    if (data != null) {
      final List decoded = jsonDecode(data);

      setState(() {
        proofs = decoded.map((e) {
          return {
            "product": e["product"],
            "image": e["image"],
            "likes": e["likes"] ?? 0,
            "comments": e["comments"] ?? []
          };
        }).toList();
      });
    }
  }

  // ✅ SAVE PROOFS
  Future<void> saveProofs() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('proofs', jsonEncode(proofs));
  }

  // ✅ LIKE
  void likePost(int index) async {
    setState(() {
      proofs[index]["likes"] = (proofs[index]["likes"] ?? 0) + 1;
    });
    await saveProofs();
  }

  // ✅ ADD COMMENT
  void addComment(int index, String comment) async {
    setState(() {
      proofs[index]["comments"].add(comment);
    });
    await saveProofs();
  }

  // ✅ DELETE
  void deleteProof(int index) async {
    setState(() {
      proofs.removeAt(index);
    });
    await saveProofs();
  }

  // ✅ COMMENT DIALOG
  void showCommentDialog(int index) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Write comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                addComment(index, text);
              }
              Navigator.pop(context);
            },
            child: const Text("Post"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proof Gallery"),
        backgroundColor: Colors.green,
      ),
      body: proofs.isEmpty
          ? const Center(child: Text("No proofs uploaded yet."))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: proofs.length,
        itemBuilder: (context, index) {
          final proof = proofs[index];
          final likes = proof["likes"];
          final comments = List<String>.from(proof["comments"]);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: Image.file(
                    File(proof["image"]),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ✅ PRODUCT NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    proof["product"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // ✅ LIKE + COMMENT + DELETE
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up,
                          color: likes > 0
                              ? Colors.green
                              : Colors.grey),
                      onPressed: () => likePost(index),
                    ),
                    Text("$likes"),

                    IconButton(
                      icon: const Icon(Icons.comment,
                          color: Colors.grey),
                      onPressed: () => showCommentDialog(index),
                    ),

                    const Spacer(),

                    IconButton(
                      icon:
                      const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteProof(index),
                    ),
                  ],
                ),

                // ✅ COMMENTS DISPLAY
                if (comments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comments
                          .map((c) => Text("• $c"))
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}