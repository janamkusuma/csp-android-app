import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants.dart';
import 'detail_screen.dart';
import 'comment_screen.dart';

class AwarenessFeedScreen extends StatefulWidget {
  const AwarenessFeedScreen({Key? key}) : super(key: key);

  @override
  State<AwarenessFeedScreen> createState() => _AwarenessFeedScreenState();
}

class _AwarenessFeedScreenState extends State<AwarenessFeedScreen> {
  String searchQuery = '';
  String filter = 'All';
  final Set<int> likedItems = {};
  Map<int, List<String>> postComments = {};

  // Map to hold video controllers for each video
  final Map<int, YoutubePlayerController> _videoControllers = {};

  final List<Map<String, String>> content = [
    {
      'type': 'article',
      'title': 'How Plastic Harms Ocean Life',
      'image': 'assets/images/article1.jpg',
      'desc': 'A deep dive into the impacts of plastic pollution on marine life.',
      'longContent': '''
Plastic pollution is one of the biggest threats to ocean life.
Every year, millions of tons of plastic waste enter the oceans. Marine animals like turtles, fish, and birds often mistake plastic for food.
This leads to severe health issues and even death.
Plastic also breaks down into microplastics, which enter the food chain and affect humans as well.
To prevent this, we must reduce plastic usage and switch to eco-friendly alternatives.
''',
      'link': 'https://www.fauna-flora.org/explained/how-does-plastic-pollution-affect-marine-life/'
    },
    {
      'type': 'article',
      'title': 'Switching to Reusable Products',
      'image': 'assets/images/article2.jpg',
      'desc': 'Simple steps to replace daily plastic usage with reusable options.',
      'longContent': '''
Switching to reusable products is one of the easiest and most effective ways to reduce plastic waste in daily life.

Single-use plastics like bags, bottles, and straws are used for a few minutes but stay in the environment for hundreds of years.

By choosing reusable alternatives such as cloth bags, steel bottles, and glass containers, we can significantly reduce the amount of plastic waste generated.

Reusable products are not only eco-friendly but also cost-effective in the long run. For example, carrying your own shopping bag can eliminate the need to buy plastic bags every time.

Small changes in our daily habits can create a big impact on the environment. Start with simple steps like refusing plastic straws and using refillable containers.

Together, these actions help protect nature and create a cleaner, healthier planet for future generations.
''',
      'link': 'https://pexpo.in/blogs/news/switching-to-reusable?srsltid=AfmBOorzWD5TW1I-F5FDRElCZi0ogqtfOCV2uuuJnxqGJc1hSTIN8Oci'
    },
    {
      'type': 'article',
      'title': 'Biodegradable Alternatives to Plastic',
      'image': 'assets/images/article3.jpg',
      'desc': 'Exploring materials that can replace harmful plastics sustainably.',
      'longContent': '''
Biodegradable alternatives to plastic are materials that can naturally break down without harming the environment.

Unlike traditional plastics, which take hundreds of years to decompose, biodegradable materials decompose quickly and safely through natural processes.

Examples include paper, jute, bamboo, and plant-based plastics made from corn starch.

These materials are increasingly being used in packaging, bags, and utensils as sustainable alternatives.

Using biodegradable products helps reduce pollution, protects wildlife, and minimizes landfill waste.

However, it is important to ensure proper disposal, as some biodegradable items require specific conditions to break down effectively.

By choosing biodegradable options, we can reduce our dependence on harmful plastics and move towards a greener future.
''',
      'link': 'https://www.sciencedirect.com/science/article/abs/pii/S0048969725005467'
    },
    {
      'type': 'video',
      'title': 'The Journey of a Plastic Bag',
      'image': 'assets/images/video_thumb1.jpg',
      'videoUrl': 'rPQc0OhmKXY',
      'desc': 'Follow a plastic bag from the store to the ocean.',
      'longContent': '''
A plastic bag may seem harmless, but its journey after use tells a different story.

After being discarded, plastic bags often end up in drains, rivers, and eventually oceans.

Along the way, they clog drainage systems, cause flooding, and harm animals that mistake them for food.

In oceans, marine creatures like turtles and fish ingest plastic, leading to serious health issues and death.

Over time, plastic breaks down into microplastics, which contaminate water and enter the food chain.

This journey highlights the long-lasting impact of a single plastic bag.

By choosing reusable bags, we can prevent this harmful cycle and protect our environment.
''',
      'link': 'https://medium.com/project-planetwise/the-journey-of-a-plastic-bag-6d2c62e59ed6'
    },
    {
      'type': 'video',
      'title': 'How Recycling Works',
      'image': 'assets/images/video_thumb2.jpg',
      'videoUrl': 'XgCPVSfQmtU',
      'desc': 'An educational look at how recycling plants process waste.',
      'longContent': '''
Recycling is a process that converts waste materials into new, usable products.

The process begins with the collection of recyclable materials such as plastic, paper, and glass.

These materials are then sorted, cleaned, and processed into raw forms that can be used again in manufacturing.

For plastic, this often involves shredding, melting, and reshaping into new items.

Recycling helps reduce the need for new raw materials, saves energy, and decreases pollution.

However, not all plastics are recyclable, and improper sorting can affect the recycling process.

Understanding how recycling works encourages responsible waste management and supports environmental sustainability.
''',
      'link': 'https://www.nationalgeographic.com/environment/article/plastic-pollution'
    },
    {
      'type': 'video',
      'title': 'DIY Eco-friendly Projects',
      'image': 'assets/images/video_thumb3.jpg',
      'videoUrl': 'a3csa3vfbzc',
      'desc': 'Learn fun DIY projects to reuse and recycle plastic.',
      'longContent': '''
DIY eco-friendly projects are a fun and creative way to reduce plastic waste.

Instead of throwing away plastic items, they can be reused and transformed into useful products.

For example, plastic bottles can be turned into plant pots, storage containers, or decorative items.

Old plastic bags can be woven into mats or reused for multiple purposes.

These projects not only reduce waste but also promote creativity and awareness about sustainability.

DIY activities can be done individually or as a group, making them great for community engagement.

By reusing materials, we give them a second life and reduce the demand for new plastic products.
''',
      'link': 'https://www.nationalgeographic.com/environment/article/plastic-pollution'
    },
  ];

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('postComments');
    if (savedData != null) {
      setState(() {
        postComments = (jsonDecode(savedData) as Map<String, dynamic>).map(
              (key, value) => MapEntry(int.parse(key), List<String>.from(value)),
        );
      });
    }
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('postComments', jsonEncode(postComments));
  }

  @override
  void dispose() {
    _videoControllers.forEach((key, ctrl) => ctrl.dispose());
    super.dispose();
  }

  // Only one video plays at a time
  void _playOnlyThis(int index) {
    _videoControllers.forEach((key, ctrl) {
      if (key == index) {
        ctrl.play();
      } else {
        ctrl.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredContent = content.where((item) {
      final matchSearch = item['title']!.toLowerCase().contains(searchQuery);
      final matchFilter = filter == 'All' ||
          item['type'] == filter.toLowerCase().substring(0, filter.length - 1);
      return matchSearch && matchFilter;
    }).toList();

    return Scaffold(
      backgroundColor: kPrimaryGreen,
      appBar: AppBar(
        title:
        const Text("Awareness Feed", style: TextStyle(color: kDarkGreen)),
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _ecoTipCard(),
            _filterTabs(),
            _searchBar(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContent.length,
                itemBuilder: (context, index) {
                  final item = filteredContent[index];
                  final actualIndex = content.indexOf(item);
                  return _contentCard(item, actualIndex);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) {}
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Awareness'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _ecoTipCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset('assets/images/plastic_bag.png', width: 70),
            const SizedBox(width: 12),
            const Expanded(
              child:
              Text('Eco Tip: Bring your own reusable bag when shopping.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['All', 'Articles', 'Videos'].map((tab) {
          return ChoiceChip(
            label: Text(tab),
            selected: filter == tab,
            onSelected: (_) => setState(() => filter = tab),
          );
        }).toList(),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
        onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
      ),
    );
  }

  Widget _contentCard(Map<String, String> item, int index) {
    // Initialize controller if video
    if (item['type'] == 'video' && !_videoControllers.containsKey(index)) {
      _videoControllers[index] = YoutubePlayerController(
        initialVideoId: item['videoUrl']!,
        flags: const YoutubePlayerFlags(
          autoPlay: false, // ❌ no autoplay
          mute: false,
        ),
      );
    }

    final controller = _videoControllers[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video or Image
          SizedBox(
            height: 220,
            width: double.infinity,
            child: item['type'] == 'video'
                ? Stack(
              fit: StackFit.expand,
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  ),
                  builder: (context, player) => player,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (controller!.value.isPlaying) {
                          controller.pause();
                        } else {
                          _playOnlyThis(index);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        controller!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            )
                : Image.asset(item['image']!, fit: BoxFit.cover),
          ),

          ListTile(
            title: Text(item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['desc']!),
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  likedItems.contains(index)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: likedItems.contains(index) ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    likedItems.contains(index)
                        ? likedItems.remove(index)
                        : likedItems.add(index);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () => _showComments(index),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  Share.share('${item['title']} - ${item['desc']}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailScreen(item: item)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComments(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return CommentScreen(
          title: content[index]['title']!,
          comments: postComments[index] ?? [],
          onCommentAdded: (comment) {
            setState(() {
              postComments.putIfAbsent(index, () => []).add(comment);
              _saveComments();
            });
          },
        );
      },
    );
  }
}