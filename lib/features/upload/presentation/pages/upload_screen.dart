import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:vybe/core/constants/app_constants.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _topicController = TextEditingController();
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedVideo;
  bool _isUploading = false;
  bool _isGeneratingScript = false;
  double _uploadProgress = 0.0;
  String _selectedAudioTrack = "Original Sound";
  List<dynamic> _audioLibrary = [];

  @override
  void initState() {
    super.initState();
    _fetchAudioLibrary();
  }

  Future<void> _fetchAudioLibrary() async {
    try {
      final res = await Dio().get(AppConstants.audioLibraryUrl);
      if (res.data["success"] == true) {
        setState(() => _audioLibrary = res.data["tracks"]);
      }
    } catch (_) {}
  }

  Future<void> _generateAIScript() async {
    if (_topicController.text.trim().isEmpty) return;

    setState(() => _isGeneratingScript = true);
    try {
      final res = await Dio().post(
        AppConstants.generateScriptUrl,
        data: {"topic": _topicController.text.trim()},
      );

      if (res.data["success"] == true) {
        final data = res.data["script_data"];
        setState(() {
          _titleController.text = "${data['hook'] ?? ''} ${data['body'] ?? ''}".trim();
          _tagsController.text = data['tags'] ?? "#ai #learning";
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("AI Script & Tags Generated! 🪄")),
          );
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isGeneratingScript = false);
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() => _selectedVideo = File(video.path));
    }
  }

  Future<void> _uploadVideoToR2() async {
    if (_selectedVideo == null || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video and add a title/script!")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final dio = Dio();
      String fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";

      // 1. Get Presigned Upload URL from Backend
      final presignedResponse = await dio.post(
        AppConstants.uploadUrl,
        data: {
          "file_name": fileName,
          "title": _titleController.text.trim(),
          "tags": _tagsController.text.trim(),
          "creator_name": "Vybe Creator",
          "audio_track": _selectedAudioTrack,
          "content_type": "video/mp4",
        },
      );

      if (presignedResponse.data["success"] == true) {
        String uploadUrl = presignedResponse.data["upload_url"];
        int fileSize = await _selectedVideo!.length();
        Stream<List<int>> fileStream = _selectedVideo!.openRead();

        // 2. Direct S3/R2 Binary Upload with Progress
        await dio.put(
          uploadUrl,
          data: fileStream,
          options: Options(
            headers: {
              Headers.contentLengthHeader: fileSize,
              "Content-Type": "video/mp4",
            },
          ),
          onSendProgress: (sent, total) {
            if (total > 0 && mounted) {
              setState(() => _uploadProgress = sent / total);
            }
          },
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lesson Uploaded Successfully! 🚀")),
          );
          setState(() {
            _selectedVideo = null;
            _topicController.clear();
            _titleController.clear();
            _tagsController.clear();
          });
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed! Please check connection.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text("Upload Micro Lesson"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Preview / Selector Box
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Center(
                  child: _selectedVideo != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 42),
                            const SizedBox(height: 8),
                            Text(
                              _selectedVideo!.path.split('/').last,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library_rounded, color: Colors.deepPurpleAccent, size: 48),
                            SizedBox(height: 10),
                            Text("Tap to Select Video from Gallery", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Groq AI Script Copilot Input
            const Text("Groq AI Script Copilot 🪄", style: TextStyle(color: Colors.amberAccent, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _topicController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter topic (e.g. Python Tips)",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1E1E2C),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: _isGeneratingScript
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.amberAccent, strokeWidth: 2))
                      : const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 30),
                  onPressed: _isGeneratingScript ? null : _generateAIScript,
                )
              ],
            ),
            const SizedBox(height: 20),

            // Title / Generated Script Input
            TextField(
              controller: _titleController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title / Lesson Script",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 15),

            // Tags Input
            TextField(
              controller: _tagsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Hashtags (e.g. #ai #python)",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 15),

            // Background Audio Dropdown
            const Text("Background Audio Track", style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAudioTrack,
                  dropdownColor: const Color(0xFF1E1E2C),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: "Original Sound", child: Text("Original Sound")),
                    ..._audioLibrary.map(
                      (track) => DropdownMenuItem(
                        value: track["title"].toString(),
                        child: Text("${track['title']} - ${track['artist']}"),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedAudioTrack = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Upload Progress Bar
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress, color: Colors.deepPurpleAccent, backgroundColor: Colors.white12),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "${(_uploadProgress * 100).toStringAsFixed(0)}% Uploading to Cloudflare R2...",
                  style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
            ],

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isUploading ? null : _uploadVideoToR2,
              child: _isUploading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Publish Micro Lesson 🚀", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
