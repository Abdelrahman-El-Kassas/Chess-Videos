import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller =
        YoutubePlayerController(
          initialVideoId: widget.videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideThumbnail: true,
          ),
        )..addListener(() {
          if (_controller.value.isReady && !_isMuted) {
            _controller.setVolume(100);
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // قمنا بإزالة الـ Column هنا لأننا لم نعد نحتاجه
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,

          // السر هنا: هذه الأزرار ستظهر داخل الفيديو نفسه
          bottomActions: [
            const CurrentPosition(), // وقت الفيديو الحالي
            const ProgressBar(
              isExpanded: true,
            ), // شريط التقديم والتأخير (المتوسع)
            // زر الصوت الخاص بنا
            IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                });

                if (_isMuted) {
                  _controller.mute();
                } else {
                  _controller.unMute();
                  _controller.setVolume(100);
                }
              },
            ),

            const PlaybackSpeedButton(), // زر تسريع الفيديو (إضافة ممتازة)
            const FullScreenButton(), // زر لتكبير الفيديو بالعرض
          ],
        ),
      ),
    );
  }
}
