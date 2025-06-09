import 'package:flutter/material.dart';
import 'package:homeease_provider/Custom/custom_appbar.dart';
import 'package:homeease_provider/Custom/custom_nav_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final Map<String, List<String>> _videoSections = {
    'AC Cleaning': [
      'https://youtu.be/JFWoLSxc7G8?si=NER41Bf8EfL22OPz',
      'https://youtu.be/AUtsCbyn1ug?si=naG81eWAVulNl7fk',
    ],
    'Plumbing': [
      'https://youtube.com/shorts/pUX89ReMd7E',
      'https://youtu.be/4Ufu_c8YYTg?si=lCPlK8wJ2MY9Mast',
    ],
    'Electrical Repair': [
      'https://youtu.be/aJZyOkxs37g?si=NWugwdiCYg9CgUwb',
      'https://youtu.be/41IgghAnhgc?si=CEKALnGerF4avHuN',
      'https://youtu.be/SnRXD-0oXZo?si=2OqR0UeadPe_I6Di',
    ],
    'Beauty': [
      'https://youtu.be/kc06SSVGK5g?si=PJtN4FHKmaeqBmFr',
      'https://youtu.be/r0_Yp3EDqRE?si=BvNFpZkpsa5RmsYy',
    ],
    'Painting':[
      'https://youtu.be/snJ8kwcNTqE?si=rCdYHZFVbNqYLv2a',
      'https://youtu.be/DPguOIM_IHk?si=IRu1i0D22zaI_6ab'
    ]
  };

  final Map<String, List<YoutubePlayerController>> _controllersBySection = {};
  final Map<String, List<String>> _titlesBySection = {};

  String? _selectedSection;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeAllSections();
  }

  Future<void> _initializeAllSections() async {
    final yt = YoutubeExplode();

    for (final section in _videoSections.entries) {
      final List<YoutubePlayerController> controllers = [];
      final List<String> titles = [];

      for (final url in section.value) {
        final videoId = YoutubePlayer.convertUrlToId(url);
        if (videoId != null) {
          controllers.add(
            YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(autoPlay: false),
            ),
          );

          try {
            final video = await yt.videos.get(url);
            titles.add(video.title);
          } catch (_) {
            titles.add('Unknown Title');
          }
        } else {
          titles.add('Invalid URL');
        }
      }

      _controllersBySection[section.key] = controllers;
      _titlesBySection[section.key] = titles;
    }

    yt.close();
    setState(() {
      _selectedSection = _videoSections.keys.first;
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final controllers in _controllersBySection.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedControllers = _controllersBySection[_selectedSection] ?? [];
    final selectedTitles = _titlesBySection[_selectedSection] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Wrap(
                      spacing: 10,
                      children:
                          _videoSections.keys.map((section) {
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    section == "AC Cleaning"
                                        ? Icons.ac_unit
                                        : section == "Plumbing"
                                        ? Icons.plumbing
                                        : section == "Electrical Repair"
                                        ? Icons.electrical_services
                                        : section == "Beauty"
                                        ? Icons.face
                                        : section == "Painting"
                                        ? Icons.brush_outlined
                                        : Icons.video_library, 
                                    size: 16,
                                    color:
                                        _selectedSection == section
                                            ? Colors.white
                                            : Colors.deepPurple,
                                  ),

                                  const SizedBox(width: 4),
                                  Text(section),
                                ],
                              ),
                              selectedColor: Colors.deepPurple,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                color:
                                    _selectedSection == section
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              selected: _selectedSection == section,
                              onSelected: (_) {
                                setState(() => _selectedSection = section);
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child:
                        selectedControllers.isEmpty
                            ? const Center(
                              child: Text(
                                'No videos available in this section.',
                              ),
                            )
                            : ListView.builder(
                              itemCount: selectedControllers.length,
                              itemBuilder: (context, index) {
                                final controller = selectedControllers[index];
                                final title = selectedTitles[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  child: KeyedSubtree(
                                    key: ValueKey('$_selectedSection-$index'),
                                    child: YoutubePlayerBuilder(
                                      player: YoutubePlayer(
                                        controller: controller,
                                        showVideoProgressIndicator: true,
                                        bottomActions: const [
                                          CurrentPosition(),
                                          ProgressBar(isExpanded: true),
                                        ],
                                      ),
                                      builder: (context, player) {
                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(12),
                                                    ),
                                                child: player,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Text(
                                                  title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 2),
    );
  }
}