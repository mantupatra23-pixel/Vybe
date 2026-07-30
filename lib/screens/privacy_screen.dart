import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isPrivate = false;
  bool _allowTips = true;
  String _dmPermission = "Everyone";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Privacy Settings 🔒', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Private Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Only approved followers can view your Vybes', style: TextStyle(color: Colors.white38, fontSize: 11)),
            value: _isPrivate,
            activeColor: Colors.amber,
            onChanged: (val) {
              setState(() => _isPrivate = val);
            },
          ),
          const Divider(color: Colors.white12),
          SwitchListTile(
            title: const Text('Allow Tips & Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Let viewers tip \$ directly on your videos', style: TextStyle(color: Colors.white38, fontSize: 11)),
            value: _allowTips,
            activeColor: Colors.amber,
            onChanged: (val) {
              setState(() => _allowTips = val);
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            title: const Text('Direct Messages (DMs)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text(_dmPermission, style: const TextStyle(color: Colors.amber, fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
            onTap: () {
              setState(() {
                _dmPermission = _dmPermission == "Everyone" ? "Followers Only" : "Everyone";
              });
            },
          ),
        ],
      ),
    );
  }
}
