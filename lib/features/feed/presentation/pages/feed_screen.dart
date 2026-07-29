import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> _videos = [];
  bool _isLoading = true;
  String? _errorMessage;

  final String feedApiUrl = "https://vybe-backend-fbsi.onrender.com/api/v1/videos/feed";

  @override
  void initState() {
    super.initState();
    _fetchFeedVideos();
  }

  Future<void> _fetchFeedVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Dio().get(
        feedApiUrl,
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.data["success"] == true) {
        setState(() {
          _videos = response.data["videos"];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Connection Error: Please ensure backend is live on Render.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 50),
                        const SizedBox(height: 10),
                        Text(_errorMessage!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                          onPressed: _fetchFeedVideos,
                          child: const Text("Retry Connection", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                )
              : _videos.isEmpty
                  ? const Center(
                      child: Text(
                        "No videos available yet!\nTap '+' to upload a lesson 🚀",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        final video = _videos[index];
                        return NetworkVideoItem(
                          videoId: video["id"],
                          videoUrl: video["cdn_url"],
                          title: video["title"] ?? "Micro Lesson",
                          tags: video["tags"] ?? "",
                        );
                      },
                    ),
    );
  }
}

class NetworkVideoItem extends StatefulWidget {
  final int videoId;
  final String videoUrl;
  final String title;
  final String tags;

  const NetworkVideoItem({
    super.key,
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.tags,
  });

  @override
  State<NetworkVideoItem> createState() => _NetworkVideoItemState();
}

class _NetworkVideoItemState extends State<NetworkVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _controller?.setLooping(true);
            _controller?.play();
          }
        });
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _isInitialized && _controller != null
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : const CircularProgressIndicator(color: Colors.deepPurpleAccent),
        ),
        Positioned(
          left: 16,
          bottom: 30,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (widget.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.tags,
                  style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
