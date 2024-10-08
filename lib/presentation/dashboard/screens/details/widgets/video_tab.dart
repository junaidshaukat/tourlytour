import 'package:flutter/material.dart';
import '/core/app_export.dart';

class VideoTab extends StatelessWidget {
  final List<ProductVideos> videos;
  const VideoTab({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60.v),
        child: const NoRecordsFound(
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    }

    return ListView.separated(
      itemCount: videos.length,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        ProductVideos video = videos[index];
        return VideoPlayerScreen(
          src: video.url,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String? src;
  const VideoPlayerScreen({super.key, this.src});

  @override
  State<VideoPlayerScreen> createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController controller;
  late Future<void> initialize;
  bool isPlaying = false;
  bool isMute = true;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    initialize = controller.initialize();
    controller.setVolume(0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              if (isPlaying) {
                setState(() {
                  isPlaying = false;
                  controller.pause();
                });
              } else {
                setState(() {
                  isPlaying = true;
                  controller.play();
                });
              }
            },
            child: SizedBox(
              height: 200.v,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (isMute) {
                              isMute = false;
                              controller.setVolume(1.0);
                            } else {
                              isMute = true;
                              controller.setVolume(0.0);
                            }
                          });
                        },
                        icon: Icon(
                          isMute == true ? Icons.volume_mute : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (!isPlaying)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isPlaying = true;
                            controller.play();
                          });
                        },
                        icon: const Icon(
                          size: 44,
                          Icons.play_circle,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 200.v,
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.h),
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
          );
        }
      },
    );
  }
}
