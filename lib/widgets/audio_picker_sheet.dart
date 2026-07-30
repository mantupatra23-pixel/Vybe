import 'package:flutter/material.dart';

class AudioPickerSheet extends StatelessWidget {
  final Function(String) onAudioSelected;

  const AudioPickerSheet({super.key, required this.onAudioSelected});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sounds = [
      {"title": "Futuristic AI Synth Beat ⚡", "artist": "Vybe Originals", "duration": "0:30"},
      {"title": "Cyberpunk Slowed + Reverb", "artist": "Groq Beats", "duration": "0:45"},
      {"title": "Lo-Fi Coding Focus Stream", "artist": "Mantu AI", "duration": "0:60"},
      {"title": "Trending Viral Reel Voiceover", "artist": "AI Voice Studio", "duration": "0:25"},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Trending Audio / Sound 🎵',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(color: Colors.white24, height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: sounds.length,
              itemBuilder: (context, index) {
                final sound = sounds[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.music_note, color: Colors.black),
                  ),
                  title: Text(sound["title"]!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: Text(sound["artist"]!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  trailing: Text(sound["duration"]!, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                  onTap: () {
                    onAudioSelected(sound["title"]!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
