import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  double _totalEarnings = 0.0;
  String _upiId = "Not Set";
  List<dynamic> _tipHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchWalletData();
  }

  Future<void> _fetchWalletData() async {
    try {
      final response = await http.get(
        Uri.parse('https://vybe-backend.onrender.com/api/v1/creator/wallet/@MantuPatra'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true && data["wallet"] != null) {
          setState(() {
            _totalEarnings = (data["wallet"]["total_earnings"] ?? 0.0).toDouble();
            _upiId = data["wallet"]["upi_id"] ?? "Not Set";
          });
        }
      }
    } catch (e) {
      print("Wallet Fetch Error: $e");
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
        title: const Text('Vybe Wallet & Tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Balance Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF202020), Color(0xFF101010)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Tip Earnings 💰', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      const SizedBox(height: 10),
                      Text(
                        '\$_totalEarnings',
                        style: const TextStyle(color: Colors.amber, fontSize: 34, fontWeight: FontWeight.black),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Linked UPI: \$_upiId', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('UPI Payout requested successfully! 🚀')),
                              );
                            },
                            child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Recent Tips Activity',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Tip History List
                _tipHistory.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'No tips received yet. Share your Vybe videos to start earning! ⚡',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics,
                        itemCount: _tipHistory.length,
                        itemBuilder: (context, index) {
                          final tip = _tipHistory[index];
                          return ListTile(
                            leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.flash_on, color: Colors.black)),
                            title: Text(tip["tipper_name"] ?? "@User", style: const TextStyle(color: Colors.white)),
                            trailing: Text("+\$${tip["amount"]}", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
