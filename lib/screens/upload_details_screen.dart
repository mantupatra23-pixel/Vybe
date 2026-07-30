import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadDetailsScreen extends StatefulWidget {
  final File videoFile;

  const UploadDetailsScreen({super.key, required this.videoFile});

  @override
  State<UploadDetailsScreen> createState() => _UploadDetailsScreenState();
}

class _UploadDetailsScreenState extends State<UploadDetailsScreen> {
  final TextEditingController _captionController = TextEditingController();
  String _visibility = "Public";
  String _audience = "No, it's not Made for Kids";
  bool _isUploading = false;
  double _progress = 0.0;

  void _showVisibilityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set visibility', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildVisibilityOption('Public', 'Anyone can search for and view'),
              _buildVisibilityOption('Unlisted', 'Anyone with the link can view'),
              _buildVisibilityOption('Private', 'Only people you choose can view'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVisibilityOption(String title, String subtitle) {
    return RadioListTile<String>(
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      value: title,
      groupValue: _visibility,
      activeColor: Colors.amber,
      onChanged: (val) {
        if (val != null) {
          setState(() => _visibility = val);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showAudiencePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select audience', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              RadioListTile<String>(
                title: const Text('Yes, it\'s Made for Kids', style: TextStyle(color: Colors.white)),
                value: 'Yes, it\'s Made for Kids',
                groupValue: _audience,
                activeColor: Colors.amber,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _audience = val);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('No, it\'s not Made for Kids', style: TextStyle(color: Colors.white)),
                value: 'No, it\'s not Made for Kids',
                groupValue: _audience,
                activeColor: Colors.amber,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _audience = val);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadVideo() async {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a caption for your Short!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _progress = 0.2;
    });

    try {
      // Get R2 Presigned URL
      final presignedRes = await http.post(
        Uri.parse('https://vybe-backend.onrender.com/api/v1/videos/generate-upload-url'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'file_name': widget.videoFile.path.split('/').last,
          'title': _captionController.text,
          'tags': '#vybe #viral',
          'creator_name': '@MantuPatra',
          'audio_track': 'Original Sound',
          'content_type': 'video/mp4'
        }),
      );

      if (presignedRes.statusCode == 200) {
        setState(() => _progress = 0.7);

        final data = json.decode(presignedRes.body);
        final String uploadUrl = data['upload_url'];

        // Direct Binary Upload to Cloudflare R2
        final bytes = await widget.videoFile.readAsBytes();
        await http.put(
          Uri.parse(uploadUrl),
          headers: {'Content-Type': 'video/mp4'},
          body: bytes,
        );

        setState(() => _progress = 1.0);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(backgroundColor: Colors.green, content: Text('Vybe Short Published to R2 & Neon DB! 🚀')),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail & Caption Input Box Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    height: 120,
                    color: Colors.grey[900],
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.movie_creation, color: Colors.amber, size: 36),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    enabled: !_isUploading,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Caption your Short...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 30),

            // Creator Handle Details
            const ListTile(
              leading: CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)),
              title: Text('MANTU PATRA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('@mantupatra7669', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            const Divider(color: Colors.white12),

            // Visibility Selector
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: const Text('Visibility', style: TextStyle(color: Colors.white54, fontSize: 12)),
              subtitle: Text(_visibility, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
              onTap: _showVisibilityPicker,
            ),
            const Divider(color: Colors.white12),

            // Audience Selector
            ListTile(
              leading: const Icon(Icons.people_alt_outlined, color: Colors.white),
              title: const Text('Select audience', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(_audience, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
              onTap: _showAudiencePicker,
            ),
            const Divider(color: Colors.white12),

            const SizedBox(height: 20),
            if (_isUploading) ...[
              LinearProgressIndicator(value: _progress, backgroundColor: Colors.grey[800], color: Colors.amber),
              const SizedBox(height: 12),
              Center(child: Text('Uploading to R2 Pipeline... ${(_progress * 100).toInt()}%', style: const TextStyle(color: Colors.amber))),
            ],
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _isUploading ? null : _uploadVideo,
                child: const Text('Upload Short', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
