import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isUploading = false;
  String? _uploadStatus;

  // Live Render Backend API
  final String backendUrl = "https://vybe-backend-fbsi.onrender.com/api/v1/videos/generate-upload-url";

  Future<void> _startUploadProcess() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a video title")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = "Requesting signed upload URL from Render Backend...";
    });

    try {
      final dio = Dio();
      
      // Step 1: Get Pre-Signed URL from FastAPI
      final response = await dio.post(backendUrl, data: {
        "file_name": "video_${DateTime.now().millisecondsSinceEpoch}.mp4",
        "content_type": "video/mp4"
      });

      if (response.data["success"] == true) {
        String uploadUrl = response.data["upload_url"];
        String cdnUrl = response.data["cdn_url"];

        setState(() {
          _uploadStatus = "Signed URL generated! Ready for Direct R2 Upload.\n\nCDN URL: $cdnUrl";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signed URL Generated Successfully! 🎉")),
        );
      }
    } catch (e) {
      setState(() {
        _uploadStatus = "Error connecting to Render API: $e";
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
        title: const Text("Create Short Video", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5), width: 1.5),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.deepPurpleAccent),
                    SizedBox(height: 10),
                    Text("Select Video (Client Compressed - 720p)", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Video Title / Topic",
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
                  labelText: "Hashtags (e.g. #coding #python)",
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isUploading ? null : _startUploadProcess,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Generate Direct Upload Link", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              if (_uploadStatus != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_uploadStatus!, style: const TextStyle(color: Colors.amberAccent, fontSize: 13)),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
