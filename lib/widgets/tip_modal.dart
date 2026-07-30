import 'package:flutter/material.dart';

class TipModal extends StatefulWidget {
  final String creatorName;

  const TipModal({super.key, required this.creatorName});

  @override
  State<TipModal> createState() => _TipModalState();
}

class _TipModalState extends State<TipModal> {
  int selectedAmount = 5;
  final TextEditingController _customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final amounts = [1, 5, 10, 20, 50];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Send Tip to ${widget.creatorName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Support your favorite AI creator directly ⚡',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Preset Amounts Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: amounts.map((amt) {
              final isSelected = selectedAmount == amt;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAmount = amt;
                    _customController.clear();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.amber : Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.amber : Colors.white12,
                    ),
                  ),
                  child: Text(
                    '\$$amt',
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Custom Tip Input
          TextField(
            controller: _customController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  selectedAmount = int.tryParse(val) ?? 0;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Or enter custom amount (\$)',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Send Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      'Tipped \$$selectedAmount to ${widget.creatorName}! ⚡',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: Text(
                'Send \$$selectedAmount Tip',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
