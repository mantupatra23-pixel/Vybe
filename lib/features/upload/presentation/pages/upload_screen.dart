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
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedVideo;
  bool _isUploading = false;
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

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() => _selectedVideo = File(video.path));
    }
  }

  Future<void> _uploadVideoToR2() async {
    if (_selectedVideo == null || _titleController.text.trim().isEmpty) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final dio = Dio();
      String fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";

      final presignedResponse = await dio.post(AppConstants.uploadUrl, data: {
        "file_name": fileName,
        "title": _titleController.text.trim(),
        "tags": _tagsController.text.trim(),
        "creator_name": "Vybe Creator",
        "audio_track": _selectedAudioTrack,
        "content_type": "video/mp4"
      });

      if (presignedResponse.data["success"] == true) {
        String uploadUrl = presignedResponse.data["upload_url"];

        int fileSize = await _selectedVideo!.length();
        Stream<List<int>> fileStream = _selectedVideo!.openRead();

        await dio.put(
          uploadUrl,
          data: fileStream,
          options: Options(headers: {Headers.contentLengthHeader: fileSize, "Content-Type": "video/mp4"}),
          onSendProgress: (sent, total) => setState(() => _uploadProgress = sent / total),
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Published Successfully!")));
        setState(() {
          _selectedVideo = null;
          _titleController.clear();
          _tagsController.clear();
        });
      }
    } catch (_) {} finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(title: const Text("Upload Lesson"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text(_selectedVideo != null ? "Video Selected ✅" : "Tap to Select Video", style: const TextStyle(color: Colors.white70)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Title", labelStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _tagsController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Tags (#ai #tech)", labelStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 15),
            DropdownButton<String>(
              value: _selectedAudioTrack,
              dropdownColor: const Color(0xFF1E1E2C),
              style: const TextStyle(color: Colors.amberAccent),
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: "Original Sound", child: Text("Original Sound")),
                ..._audioLibrary.map((track) => DropdownMenuItem(value: track["title"].toString(), child: Text(track["title"].toString())))
              ],
              onChanged: (val) => setState(() => _selectedAudioTrack = val!),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, minimumSize: const Size(double.infinity, 48)),
              onPressed: _isUploading ? null : _uploadVideoToR2,
              child: _isUploading ? CircularProgressIndicator(value: _uploadProgress) : const Text("Publish to Vybe Cloud", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
