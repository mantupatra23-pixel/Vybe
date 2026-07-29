import 'package:flutter/material.dart';

class QuizDialog extends StatefulWidget {
  const QuizDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuizDialog(),
    );
  }

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  int selectedOption = -1;
  bool showResult = false;
  final int correctIndex = 1; // Correct answer index

  final List<String> options = [
    "A) print('Hello')",
    "B) console.log('Hello')",
    "C) System.out.println('Hello')",
    "D) echo 'Hello'"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Chip(
                avatar: Icon(Icons.bolt, color: Colors.amber, size: 18),
                label: Text("+20 XP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Color(0xFF2D2D44),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Quick Check 🧠",
            style: TextStyle(color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "How do you print 'Hello' in Python?",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...List.generate(options.length, (index) {
            Color border = Colors.white24;
            Color bg = const Color(0xFF2A2A3D);

            if (showResult) {
              if (index == correctIndex) {
                border = Colors.greenAccent;
                bg = Colors.green.withOpacity(0.2);
              } else if (index == selectedOption) {
                border = Colors.redAccent;
                bg = Colors.red.withOpacity(0.2);
              }
            } else if (index == selectedOption) {
              border = Colors.deepPurpleAccent;
            }

            return GestureDetector(
              onTap: () {
                if (!showResult) {
                  setState(() => selectedOption = index);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      options[index],
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    if (showResult && index == correctIndex)
                      const Icon(Icons.check_circle, color: Colors.greenAccent)
                    else if (showResult && index == selectedOption)
                      const Icon(Icons.cancel, color: Colors.redAccent)
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: selectedOption == -1
                  ? null
                  : () {
                      if (!showResult) {
                        setState(() => showResult = true);
                      } else {
                        Navigator.pop(context);
                      }
                    },
              child: Text(
                showResult ? "Continue (+20 XP)" : "Submit Answer",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
