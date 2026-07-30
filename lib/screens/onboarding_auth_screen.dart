import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../main.dart';

class OnboardingAuthScreen extends StatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  State<OnboardingAuthScreen> createState() => _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends State<OnboardingAuthScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Autonomous AI\nVideo Generation",
      "subtitle": "Create, render, and stream short reels in seconds with Groq AI Studio.",
      "badge": "AI POWERED ⚡",
      "icon": Icons.auto_awesome_rounded,
      "colors": [const Color(0xFFFF9900), const Color(0xFFFF0055)]
    },
    {
      "title": "Earn Direct Tips &\nInstant Payouts",
      "subtitle": "Monetize content directly via instant UPI & Cloudflare pipeline.",
      "badge": "MONETIZE 💰",
      "icon": Icons.account_balance_wallet_rounded,
      "colors": [const Color(0xFF00F2FE), const Color(0xFF4FACFE)]
    },
    {
      "title": "Interactive Live\nGrid & Gaming",
      "subtitle": "Engage in real-time streams with dynamic tipping overlays and ranks.",
      "badge": "LIVE COMMUNITY 📡",
      "icon": Icons.cell_tower_rounded,
      "colors": [const Color(0xFF11998E), const Color(0xFF38EF7D)]
    },
  ];

  void _proceedToApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  Future<void> _handleGoogleAuth() async {
    setState(() => _isLoading = true);
    final userData = await FirebaseService.signInWithGoogle();
    setState(() => _isLoading = false);

    if (userData != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text('Logged in successfully as ${userData["name"]}! 🚀', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );
      _proceedToApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dynamic Glowing Gradient Orbs
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: _currentPage == 0 ? -50 : -100,
            left: _currentPage == 1 ? -50 : 100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _onboardingData[_currentPage]["colors"][0].withOpacity(0.4),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final item = _onboardingData[index];
              final List<Color> colors = item["colors"];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Glassmorphic Hero Preview Card
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors[0].withOpacity(0.25), colors[1].withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: colors[0].withOpacity(0.5), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: colors[0].withOpacity(0.15), blurRadius: 30, spreadRadius: 2),
                        ],
                      ),
                      child: Center(
                        child: Icon(item["icon"], size: 80, color: colors[0]),
                      ),
                    ),
                    const SizedBox(height: 35),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors[0].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors[0]),
                      ),
                      child: Text(
                        item["badge"]!,
                        style: TextStyle(color: colors[0], fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      item["title"]!,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item["subtitle"]!,
                      style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top Right Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _proceedToApp,
              child: const Text('Explore Feed ➔', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.amber : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shadowColor: Colors.amber.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _showAuthBottomSheet(context);
                      }
                    },
                    child: Text(
                      _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Continue',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAuthBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text('Welcome to Vybe', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Sign in to publish videos, send tips & live stream', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 25),

              _buildSocialAuthButton(
                icon: Icons.g_mobiledata_rounded,
                label: _isLoading ? 'Signing in...' : 'Continue with Google',
                bgColor: Colors.white,
                textColor: Colors.black,
                onTap: _isLoading ? () {} : () {
                  Navigator.pop(context);
                  _handleGoogleAuth();
                },
              ),
              const SizedBox(height: 12),

              _buildSocialAuthButton(
                icon: Icons.facebook,
                label: 'Continue with Facebook',
                bgColor: const Color(0xFF1877F2),
                textColor: Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  _proceedToApp();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialAuthButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
