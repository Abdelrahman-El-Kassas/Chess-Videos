import 'package:flutter/material.dart';
import 'package:watch_videos/features/videos_screen/data/ids.dart';
import 'package:watch_videos/features/videos_screen/presentation/screens/video_playerscreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
          "Learn Chess",
          style: TextStyle(
            color: Color.fromARGB(255, 213, 18, 18),
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 12),
            child: Icon(Icons.search),
          ),
          Icon(Icons.notifications),
        ],
      ),

      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: ids.length,
        itemBuilder: (context, index) {
          return InkWell(
            // استخدمنا InkWell لكي نجعل العنصر قابلاً للضغط
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayerScreen(videoId: ids[index]['id']),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    YoutubePlayer.getThumbnail(videoId: ids[index]['id']),
                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    ids[index]['title'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
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
