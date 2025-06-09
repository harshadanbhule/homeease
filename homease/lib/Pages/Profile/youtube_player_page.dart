import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubePlayerPage extends StatefulWidget {
  const YoutubePlayerPage({super.key});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  final List<String> _videoUrls = [
    'https://youtube.com/shorts/tZal20qCSkc?si=YPWGLQL2IlSqbXAZ',
    'https://youtu.be/8jxRn-T_LCs?si=Xd7MgFcDNslPkgsD',
    'https://youtube.com/shorts/pUX89ReMd7E?si=KRavOV4z2Q3VJeKi',
  ];

  final List<YoutubePlayerController> _controllers = [];
  final List<String> _titles = [];

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    final yt = YoutubeExplode();

    for (var url in _videoUrls) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        // Create controller
        _controllers.add(
          YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          ),
        );

        // Fetch title
        try {
          final video = await yt.videos.get(url);
          _titles.add(video.title);
        } catch (_) {
          _titles.add("Unknown Title");
        }
      } else {
        _titles.add("Invalid URL");
      }
    }

    yt.close();

    setState(() {}); // Refresh UI after data is loaded
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch & Learn'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _controllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controllers[index],
                      showVideoProgressIndicator: true,
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                      ],
                    ),
                    builder: (context, player) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          player,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _titles.isNotEmpty && index < _titles.length
                                  ? _titles[index]
                                  : 'Loading title...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
