import 'package:flutter/material.dart';

class BoostScreen extends StatefulWidget {
  const BoostScreen({super.key});

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  double _budget = 10.0;
  String _targetAudience = "Tech & AI Enthusiasts";

  @override
  Widget build(BuildContext context) {
    int estimatedViews = (_budget * 1200).toInt();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Vybe Post Boost 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                children: [
                  const Text('Estimated Projected Reach', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('$estimatedViews Views', style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.black)),
                  const SizedBox(height: 4),
                  Text('Budget: \$${_budget.toInt()}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text('Boost Budget (\$)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Slider(
              value: _budget,
              min: 5,
              max: 100,
              divisions: 19,
              activeColor: Colors.amber,
              inactiveColor: Colors.white24,
              label: '\$${_budget.toInt()}',
              onChanged: (val) {
                setState(() {
                  _budget = val;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text('Target Audience Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _targetAudience,
              dropdownColor: const Color(0xFF141414),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF141414),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ["Tech & AI Enthusiasts", "Entertainment & Music", "Gaming & E-Sports", "Lifestyle & Vlogs"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _targetAudience = val);
              },
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Boost campaign submitted for \$${_budget.toInt()}! 🚀')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Start Boost Campaign', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
