import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class DetailScreen extends StatefulWidget {
  final Map<String, String> item;
  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    if (widget.item['type'] == 'video') {
      final videoId = widget.item['videoUrl']!;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true, // Auto-play in detail screen
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.item['title']!),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video or Image
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: widget.item['type'] == 'video' && _ytController != null
                  ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _ytController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                ),
                builder: (context, player) => Container(
                  width: double.infinity,
                  height: 220,
                  child: player,
                ),
              )
                  : Image.asset(
                widget.item['image']!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              widget.item['title']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              widget.item['longContent'] ?? widget.item['desc']!,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Read More Button
            if (widget.item['link'] != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(widget.item['link']!);
                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text(
                    "Read Full Article",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.greenAccent,
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}




