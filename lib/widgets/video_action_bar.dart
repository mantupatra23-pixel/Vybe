import 'package:flutter/material.dart';

class VideoActionBar extends StatefulWidget {
  final int initialLikes;
  final int commentsCount;
  final VoidCallback onCommentPressed;

  const VideoActionBar({
    super.key,
    this.initialLikes = 0,
    this.commentsCount = 0,
    required this.onCommentPressed,
  });

  @override
  State<VideoActionBar> createState() => _VideoActionBarState();
}

class _VideoActionBarState extends State<VideoActionBar> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like Button
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.white,
          label: "$likeCount",
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              likeCount += isLiked ? 1 : -1;
            });
          },
        ),
        const SizedBox(height: 16),

        // Comment Button
        _buildActionButton(
          icon: Icons.comment_rounded,
          color: Colors.white,
          label: "${widget.commentsCount}",
          onTap: widget.onCommentPressed,
        ),
        const SizedBox(height: 16),

        // Duet / Remix Button
        _buildActionButton(
          icon: Icons.splitscreen_rounded,
          color: Colors.amber,
          label: "Duet",
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening AI Duet Studio... 🎬')),
            );
          },
        ),
        const SizedBox(height: 16),

        // Share Button
        _buildActionButton(
          icon: Icons.share_rounded,
          color: Colors.white,
          label: "Share",
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reel Link Copied!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
