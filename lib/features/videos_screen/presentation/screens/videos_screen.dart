import 'package:flutter/material.dart';
import 'package:watch_videos/service/video_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_playerscreen.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final VideoService _videoService = VideoService();

  Widget _buildVideoCard(dynamic video, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoId: video['id'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  YoutubePlayer.getThumbnail(videoId: video['id']),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              video['title'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            // خط فاصل خفيف بين الفيديوهات لزيادة الأناقة
            const Divider(color: Colors.black12, thickness: 1), 
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          "Chess Videos",
          style: TextStyle(
            color: Color.fromARGB(255, 213, 18, 18),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 12),
            child: Icon(Icons.search),
          ),
          Icon(Icons.notifications),
        ],
      ),
      
      body: FutureBuilder<List<dynamic>>(
        future: _videoService.fetchVideos(), 
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'error occured: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final List<dynamic> videos = snapshot.data!;
            
            return Center(
              child: ConstrainedBox(
                // السر هنا: لا نسمح بعرض القائمة أن يتجاوز 700 بكسل أبداً
                constraints: const BoxConstraints(maxWidth: 700),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return _buildVideoCard(videos[index], context);
                  },
                ),
              ),
            );
          }
          
          return const Center(child: Text('There is no Videos now'));
        },
      ),
    );
  }
}