import 'dart:async';
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
  String _currentSubtitleWord = "";
  int _timerSeconds = 5;
  Timer? _pollTimer;
  bool _pollActive = true;

  @override
  void initState() {
    super.initState();
    _initVideoAndSubtitles();
    _startPollTimer();
  }

  void _initVideoAndSubtitles() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video["cdn_url"]))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller?.setLooping(true);
          _controller?.play();
        }
      });

    // Auto AI Subtitles Fetch
    try {
      final res = await Dio().post(
        AppConstants.autoSubtitlesUrl,
        data: {"video_title": widget.video["title"] ?? ""},
      );
      if (res.data["success"] == true) {
        List subs = res.data["subtitles"];
        for (var sub in subs) {
          Future.delayed(Duration(milliseconds: (sub["start"] * 1000).toInt()), () {
            if (mounted) setState(() => _currentSubtitleWord = sub["word"]);
          });
        }
      }
    } catch (_) {}
  }

  void _startPollTimer() {
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        if (mounted) setState(() => _timerSeconds--);
      } else {
        _pollTimer?.cancel();
        if (mounted) setState(() => _pollActive = false);
      }
    });
  }

  void _showTipDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TipCreatorDrawer(
        creatorName: widget.video["creator_name"] ?? "Vybe Creator",
        upiId: widget.video["creator_upi_id"] ?? "",
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player Background
        Center(
          child: _isInitialized && _controller != null
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : const CircularProgressIndicator(color: Colors.amberAccent),
        ),

        // AI Dynamic Subtitles Overlay
        if (_currentSubtitleWord.isNotEmpty)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                ),
                child: Text(
                  _currentSubtitleWord,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        // Live Interactive Quiz Poll Overlay
        if (_pollActive)
          Positioned(
            top: 170,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurpleAccent),
              ),
              child: Column(
                children: [
                  Text(
                    "⚡ Live Quiz ($_timerSeconds s)",
                    style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: const Size(100, 30),
                    ),
                    onPressed: () {
                      setState(() => _pollActive = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("+50 XP Earned! ⚡")),
                      );
                    },
                    child: const Text("Option A", style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),

        // Bottom Left Creator Info
        Positioned(
          left: 16,
          bottom: 30,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${widget.video['creator_name'] ?? 'Vybe Creator'}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                widget.video['title'] ?? "",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Bottom Right Creator Tip Action Button
        Positioned(
          right: 16,
          bottom: 40,
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.monetization_on_rounded, color: Colors.amberAccent, size: 38),
                onPressed: _showTipDrawer,
              ),
              const Text("Tip ⚡", style: TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

// Creator Support / Tip Bottom Sheet Drawer
class TipCreatorDrawer extends StatefulWidget {
  final String creatorName;
  final String upiId;

  const TipCreatorDrawer({super.key, required this.creatorName, required this.upiId});

  @override
  State<TipCreatorDrawer> createState() => _TipCreatorDrawerState();
}

class _TipCreatorDrawerState extends State<TipCreatorDrawer> {
  final _amountController = TextEditingController(text: "50");

  Future<void> _sendTip() async {
    try {
      await Dio().post(AppConstants.tipCreatorUrl, data: {
        "creator_name": widget.creatorName,
        "tipper_name": "Vybe Supporter",
        "amount": double.tryParse(_amountController.text.trim()) ?? 50.0,
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Supported @${widget.creatorName} with ₹${_amountController.text}! 🎉")),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Support @${widget.creatorName}",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            widget.upiId.isNotEmpty ? "UPI: ${widget.upiId}" : "Direct Creator Wallet Tip",
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.amberAccent, fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              labelText: "Tip Amount (₹)",
              labelStyle: TextStyle(color: Colors.white54),
              prefixText: "₹ ",
              prefixStyle: TextStyle(color: Colors.amberAccent, fontSize: 22),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: _sendTip,
            child: const Text("Send Instant Tip ⚡", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
