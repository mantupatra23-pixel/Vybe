import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'upload_details_screen.dart';

class CameraRecorderScreen extends StatefulWidget {
  const CameraRecorderScreen({super.key});

  @override
  State<CameraRecorderScreen> createState() => _CameraRecorderScreenState();
}

class _CameraRecorderScreenState extends State<CameraRecorderScreen> {
  bool isRecording = false;
  String selectedSound = "Add sound";
  String selectedDuration = "15 s";
  String selectedSpeed = "1x";
  bool isFlashOn = false;
  bool isFrontCamera = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadDetailsScreen(videoFile: File(video.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Viewport Simulation
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF101010),
            child: Center(
              child: Icon(
                isFrontCamera ? Icons.person : Icons.videocam,
                size: 100,
                color: Colors.white10,
              ),
            ),
          ),

          // Top Bar (Close, Add Sound, Magic Effects)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSound = "Try this sound - Sultan";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.music_note, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          selectedSound,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // Right Side Floating Camera Tools Bar
          Positioned(
            right: 16,
            top: 110,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  _buildToolIcon(Icons.flip_camera_android, "Flip", () {
                    setState(() => isFrontCamera = !isFrontCamera);
                  }),
                  _buildToolIcon(Icons.timer_outlined, "Timer", () {}),
                  _buildToolIcon(Icons.av_timer, selectedDuration, () {
                    setState(() => selectedDuration = selectedDuration == "15 s" ? "60 s" : "15 s");
                  }),
                  _buildToolIcon(Icons.auto_fix_high, "Effects", () {}),
                  _buildToolIcon(Icons.speed, selectedSpeed, () {
                    setState(() => selectedSpeed = selectedSpeed == "1x" ? "2x" : "1x");
                  }),
                  _buildToolIcon(Icons.portrait, "Green Screen", () {}),
                  _buildToolIcon(Icons.brush, "Retouch", () {}),
                  _buildToolIcon(Icons.filter_vintage, "Filters", () {}),
                  _buildToolIcon(isFlashOn ? Icons.flash_on : Icons.flash_off, "Flash", () {
                    setState(() => isFlashOn = !isFlashOn);
                  }),
                ],
              ),
            ),
          ),

          // Bottom Shutter & Gallery Row
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery Upload Button
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white38),
                            ),
                            child: const Icon(Icons.photo_library, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),

                    // Recording Shutter Button
                    GestureDetector(
                      onTap: () {
                        setState(() => isRecording = !isRecording);
                        if (!isRecording) {
                          _pickFromGallery();
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isRecording ? Colors.amber : Colors.red,
                            shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: isRecording ? BorderRadius.circular(12) : null,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
