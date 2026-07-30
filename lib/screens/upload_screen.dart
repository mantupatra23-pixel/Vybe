import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  File? _selectedVideo;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
    }
  }

  Future<void> _uploadDirectToR2() async {
    if (_selectedVideo == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select video and title!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.1;
    });

    try {
      // Step 1: Request Presigned URL from Backend
      final presignedRes = await http.post(
        Uri.parse('https://vybe-backend.onrender.com/api/upload/presigned-url'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'file_name': _selectedVideo!.path.split('/').last,
          'file_type': 'video/mp4'
        }),
      );

      if (presignedRes.statusCode != 200) {
        throw Exception('Failed to get R2 presigned URL');
      }

      final data = json.decode(presignedRes.body);
      final String uploadUrl = data['upload_url'];
      final String publicUrl = data['public_url'];

      setState(() {
        _uploadProgress = 0.4;
      });

      // Step 2: Direct Binary Upload to Cloudflare R2
      final videoBytes = await _selectedVideo!.readAsBytes();
      final r2Res = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'video/mp4'},
        body: videoBytes,
      );

      if (r2Res.statusCode != 200) {
        throw Exception('R2 Direct Upload Failed');
      }

      setState(() {
        _uploadProgress = 0.8;
      });

      // Step 3: Complete Metadata in Neon DB
      await http.post(
        Uri.parse('https://vybe-backend.onrender.com/api/upload/complete'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _titleController.text,
          'description': _descController.text,
          'video_url': publicUrl,
          'creator_handle': '@MantuPatra'
        }),
      );

      setState(() {
        _uploadProgress = 1.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Uploaded Directly to Cloudflare R2 & Neon DB! ⚡'),
          ),
        );
        setState(() {
          _selectedVideo = null;
          _titleController.clear();
          _descController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text('Upload Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create New Vybe', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _isUploading ? null : _pickVideo,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: _selectedVideo != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 45, color: Colors.greenAccent),
                          const SizedBox(height: 8),
                          Text(_selectedVideo!.path.split('/').last, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_rounded, size: 45, color: Colors.amber),
                          SizedBox(height: 8),
                          Text('Select Video for R2 Pipeline', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              enabled: !_isUploading,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController,
              enabled: !_isUploading,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 25),
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress, backgroundColor: Colors.grey[800], color: Colors.amber),
              const SizedBox(height: 12),
              Text('Uploading Direct to Cloudflare R2... ${(_uploadProgress * 100).toInt()}%', style: const TextStyle(color: Colors.amber)),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isUploading ? null : _uploadDirectToR2,
                child: const Text('Publish via R2 Pipeline', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
