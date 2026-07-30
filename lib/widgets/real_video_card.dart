import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/api_service.dart';
import 'video_action_bar.dart';
import 'tip_modal.dart';

class RealVideoCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const RealVideoCard({super.key, required this.item});

  @override
  State<RealVideoCard> createState() => _RealVideoCardState();
}

class _RealVideoCardState extends State<RealVideoCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.item["video_url"]),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.play();
        }
      }).catchError((e) {
        print("Video Init Error: $e");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _openTipSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TipModal(creatorName: widget.item["creator"]),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Real-Time Comments',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const Divider(color: Colors.white24, height: 20),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.amber, child: Text('M', style: TextStyle(color: Colors.black))),
                        title: Text('@MantuPatra', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        subtitle: Text('Super fast playback via Cloudflare R2! ⚡', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.amber),
                      onPressed: () async {
                        if (_commentController.text.isNotEmpty) {
                          final text = _commentController.text;
                          _commentController.clear();
                          Navigator.pop(context);
                          await ApiService.addComment(widget.item["id"] ?? 1, text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comment Published! 💬')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isInitialized) {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        }
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            child: _isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.amber),
                        SizedBox(height: 12),
                        Text('Streaming Reel...', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
          ),

          if (_isInitialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(Icons.play_arrow_rounded, size: 80, color: Colors.white54),
            ),

          Positioned(
            left: 16,
            bottom: 25,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item["creator"],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.item["title"],
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => _openTipSheet(context),
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text('Tip \$', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 30,
            child: VideoActionBar(
              initialLikes: widget.item["likes"],
              commentsCount: widget.item["comments"],
              onCommentPressed: () => _showCommentsSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
