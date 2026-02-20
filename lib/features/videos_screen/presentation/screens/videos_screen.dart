import 'package:flutter/material.dart';
import 'package:watch_videos/service/video_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'video_playerscreen.dart'; // تأكد من صحة مسار شاشة العرض


class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // أخذ نسخة من كلاس الخدمات لكي نستخدم الدالة الموجودة بداخله
  final VideoService _videoService = VideoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          "Chess Videos", // قمت بتعديل الاسم ليتناسب مع محتوى التطبيق
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
      
      // هنا نمرر الدالة من كلاس الخدمات بكل سهولة
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
                'حدث خطأ: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final List<dynamic> videos = snapshot.data!;
            
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoId: videos[index]['id'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            YoutubePlayer.getThumbnail(videoId: videos[index]['id']),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.red),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          videos[index]['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          
          return const Center(child: Text('There is no Videos now'));
        },
      ),
    );
  }
}