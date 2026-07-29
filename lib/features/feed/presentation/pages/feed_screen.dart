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
    _fetchFeedVideos();
  }

  Future<void> _fetchFeedVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Dio().get(
        AppConstants.feedUrl,
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
        _errorMessage = "Unable to connect to Vybe Cloud. Tap retry!";
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 50),
                      const SizedBox(height: 10),
                      Text(_errorMessage!, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                        onPressed: _fetchFeedVideos,
                        child: const Text("Retry", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              : _videos.isEmpty
                  ? const Center(
                      child: Text("No videos in feed!\nTap '+' to upload.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
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
                          creatorName: video["creator_name"] ?? "Vybe Creator",
                          audioTrack: video["audio_track"] ?? "Original Sound",
                          initialLikes: video["likes"] ?? 0,
                          initialViews: video["views"] ?? 0,
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
  final String creatorName;
  final String audioTrack;
  final int initialLikes;
  final int initialViews;

  const NetworkVideoItem({
    super.key,
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.tags,
    required this.creatorName,
    required this.audioTrack,
    required this.initialLikes,
    required this.initialViews,
  });

  @override
  State<NetworkVideoItem> createState() => _NetworkVideoItemState();
}

class _NetworkVideoItemState extends State<NetworkVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
    _initPlayerAndRegisterView();
  }

  void _initPlayerAndRegisterView() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller?.setLooping(true);
          _controller?.play();
        }
      });

    Dio().post(AppConstants.getViewUrl(widget.videoId)).catchError((_) {});
  }

  Future<void> _likeVideo() async {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });

    try {
      await Dio().post(AppConstants.getLikeUrl(widget.videoId));
    } catch (_) {}
  }

  void _showCommentsDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DynamicCommentsWidget(videoId: widget.videoId),
    );
  }

  void _showQuizModal() async {
    try {
      final res = await Dio().get(AppConstants.getQuizzesUrl(widget.videoId));
      if (res.data["success"] == true && res.data["quizzes"].isNotEmpty) {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF1E1E2C),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) => DynamicQuizWidget(quizzes: res.data["quizzes"]),
        );
      }
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
              Text("@${widget.creatorName}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 6),
              Text(widget.tags, style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white70, size: 15),
                  const SizedBox(width: 5),
                  Expanded(child: Text(widget.audioTrack, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 40,
          child: Column(
            children: [
              IconButton(
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.redAccent : Colors.white, size: 32),
                onPressed: _likeVideo,
              ),
              Text("$_likes", style: const TextStyle(color: Colors.white, fontSize: 12)),
              const SizedBox(height: 15),
              IconButton(
                icon: const Icon(Icons.comment_rounded, color: Colors.white, size: 30),
                onPressed: _showCommentsDrawer,
              ),
              const SizedBox(height: 15),
              IconButton(
                icon: const Icon(Icons.lightbulb_outline_rounded, color: Colors.amberAccent, size: 32),
                onPressed: _showQuizModal,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class DynamicCommentsWidget extends StatefulWidget {
  final int videoId;
  const DynamicCommentsWidget({super.key, required this.videoId});

  @override
  State<DynamicCommentsWidget> createState() => _DynamicCommentsWidgetState();
}

class _DynamicCommentsWidgetState extends State<DynamicCommentsWidget> {
  List<dynamic> _comments = [];
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final res = await Dio().get(AppConstants.getCommentsUrl(widget.videoId));
      if (res.data["success"] == true) {
        setState(() => _comments = res.data["comments"]);
      }
    } catch (_) {}
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;
    try {
      await Dio().post(AppConstants.addCommentUrl, data: {
        "video_id": widget.videoId,
        "user_name": "Vybe User",
        "comment_text": _commentController.text.trim(),
      });
      _commentController.clear();
      _fetchComments();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Comments", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final item = _comments[index];
                return ListTile(
                  title: Text(item["user_name"], style: const TextStyle(color: Colors.amberAccent, fontSize: 13)),
                  subtitle: Text(item["comment_text"], style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(hintText: "Add a comment...", hintStyle: TextStyle(color: Colors.white38)),
                ),
              ),
              IconButton(icon: const Icon(Icons.send, color: Colors.deepPurpleAccent), onPressed: _postComment)
            ],
          )
        ],
      ),
    );
  }
}

class DynamicQuizWidget extends StatelessWidget {
  final List<dynamic> quizzes;
  const DynamicQuizWidget({super.key, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final q = quizzes[index];
          List options = q["options"] is String ? List.from(jsonDecode(q["options"])) : List.from(q["options"]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Q: ${q['question']}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...options.map((opt) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C3E)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("+50 XP Earned! ⚡")));
                        Navigator.pop(context);
                      },
                      child: Text(opt.toString(), style: const TextStyle(color: Colors.white)),
                    ),
                  )),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}
