import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

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
  String? _statusMessage;

  final String backendUrl = "https://vybe-backend-fbsi.onrender.com/api/v1/videos/generate-upload-url";

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
        _statusMessage = "Video selected! Ready to upload.";
      });
    }
  }

  Future<void> _uploadVideoToR2() async {
    if (_selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a video first!")),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title for your video.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _statusMessage = "Step 1/2: Requesting presigned URL from Render...";
    });

    try {
      final dio = Dio();
      String fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";

      final presignedResponse = await dio.post(backendUrl, data: {
        "file_name": fileName,
        "title": _titleController.text.trim(),
        "tags": _tagsController.text.trim(),
        "content_type": "video/mp4"
      });

      if (presignedResponse.data["success"] == true) {
        String uploadUrl = presignedResponse.data["upload_url"];
        String cdnUrl = presignedResponse.data["cdn_url"];

        setState(() {
          _statusMessage = "Step 2/2: Uploading video to Cloudflare R2...";
        });

        int fileSize = await _selectedVideo!.length();
        Stream<List<int>> fileStream = _selectedVideo!.openRead();

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
            setState(() {
              _uploadProgress = sent / total;
            });
          },
        );

        setState(() {
          _statusMessage = "🎉 Success! Video uploaded & AI Quiz Generated!\nCDN URL:\n$cdnUrl";
          _selectedVideo = null;
          _titleController.clear();
          _tagsController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video Published Successfully!")),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error during upload: $e";
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text("Upload Micro-Lesson", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isUploading ? null : _pickVideo,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedVideo != null ? Colors.greenAccent : Colors.deepPurpleAccent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedVideo != null ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
                        size: 50,
                        color: _selectedVideo != null ? Colors.greenAccent : Colors.deepPurpleAccent,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedVideo != null ? "Video Selected ✅ (Tap to Change)" : "Tap to Select Video from Gallery",
                        style: TextStyle(color: _selectedVideo != null ? Colors.greenAccent : Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Lesson Title",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _tagsController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Tags (e.g. #python #ai)",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 25),
              if (_isUploading) ...[
                LinearProgressIndicator(value: _uploadProgress, color: Colors.deepPurpleAccent, backgroundColor: Colors.white12),
                const SizedBox(height: 10),
                Text("${(_uploadProgress * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
              ],
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isUploading ? null : _uploadVideoToR2,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Publish Video to Cloudflare R2", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              if (_statusMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_statusMessage!, style: const TextStyle(color: Colors.amberAccent, fontSize: 13)),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
