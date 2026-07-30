import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiStudioScreen extends StatefulWidget {
  const AiStudioScreen({super.key});

  @override
  State<AiStudioScreen> createState() => _AiStudioScreenState();
}

class _AiStudioScreenState extends State<AiStudioScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _scriptResult;

  Future<void> _generateScript() async {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _scriptResult = null;
    });

    try {
      final res = await http.post(
        Uri.parse('https://vybe-backend.onrender.com/api/v1/smart/generate-script'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'topic': _topicController.text.trim()}),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _scriptResult = data['script_data'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AI Content Studio 🧠', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Viral Reels Script via Groq AI',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g. AI tools for coders, Space facts...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF141414),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.amber)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _generateScript,
                icon: const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? 'Generating Script...' : 'Generate AI Script', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 25),
              const Center(child: CircularProgressIndicator(color: Colors.amber)),
            ],
            if (_scriptResult != null) ...[
              const SizedBox(height: 25),
              _buildResultCard('HOOK 🎯', _scriptResult!['hook'] ?? '', Colors.amber),
              const SizedBox(height: 12),
              _buildResultCard('SCRIPT BODY 🎬', _scriptResult!['body'] ?? '', Colors.white),
              const SizedBox(height: 12),
              _buildResultCard('CALL TO ACTION ⚡', _scriptResult!['cta'] ?? '', Colors.greenAccent),
              const SizedBox(height: 12),
              _buildResultCard('TRENDING TAGS 🏷️', _scriptResult!['tags'] ?? '', Colors.blueAccent),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String content, Color labelColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SelectableText(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
