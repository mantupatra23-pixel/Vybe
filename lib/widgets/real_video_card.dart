import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.item["video_url"]),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Comments',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.amber, child: Text('N')),
                      title: Text('Neon DB Sync', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      subtitle: Text('Directly connected to Neon PostgreSQL! ⚡', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  suffixIcon: const Icon(Icons.send, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Stack(
        children: [
          // Video Surface
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
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
          ),

          // Play Icon Overlay when Paused
          if (_isInitialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(Icons.play_arrow, size: 80, color: Colors.white54),
            ),

          // Bottom Info Overlay
          Positioned(
            left: 16,
            bottom: 20,
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

          // Right Action Bar
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
