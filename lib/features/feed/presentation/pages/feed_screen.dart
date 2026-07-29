import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';
import 'package:vybe/core/constants/app_constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> _videos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final res = await dio.get(AppConstants.feedUrl);
      if (res.data["success"] == true) {
        setState(() {
          _videos = res.data["videos"];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Connecting to Vybe Cloud... Tap Retry!";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurpleAccent),
                  SizedBox(height: 15),
                  Text("Waking up Vybe Cloud...", style: TextStyle(color: Colors.white54, fontSize: 12))
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded, color: Colors.amberAccent, size: 50),
                      const SizedBox(height: 12),
                      Text(_errorMessage!, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                        onPressed: _fetchFeed,
                        child: const Text("Retry Connection", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return NetworkVideoItem(video: video);
                  },
                ),
    );
  }
}

class NetworkVideoItem extends StatefulWidget {
  final Map<String, dynamic> video;
  const NetworkVideoItem({super.key, required this.video});

  @override
  State<NetworkVideoItem> createState() => _NetworkVideoItemState();
}

class _NetworkVideoItemState extends State<NetworkVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video["cdn_url"]))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller?.setLooping(true);
          _controller?.play();
        }
      });
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
              ? AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!))
              : const CircularProgressIndicator(color: Colors.deepPurpleAccent),
        ),
        Positioned(
          left: 16,
          bottom: 30,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("@${widget.video['creator_name'] ?? 'Vybe Creator'}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text(widget.video['title'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
