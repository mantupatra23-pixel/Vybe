import 'package:flutter/material.dart';
import '../main.dart';

class OnboardingAuthScreen extends StatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  State<OnboardingAuthScreen> createState() => _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends State<OnboardingAuthScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showLoginSheet = false;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Autonomous AI\nVideo Generation",
      "subtitle": "Create, render, and stream short reels in seconds with Groq AI Studio.",
      "badge": "AI POWERED ⚡"
    },
    {
      "title": "Earn Direct Tips &\nInstant Payouts",
      "subtitle": "Support your favorite creators directly via UPI & Cloudflare pipeline.",
      "badge": "MONETIZE 💰"
    },
    {
      "title": "Interactive Live\nGrid & Gaming",
      "subtitle": "Engage in real-time streams with dynamic tipping overlays and ranks.",
      "badge": "LIVE COMMUNITY 📡"
    },
  ];

  void _proceedToApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dynamic PageView Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final item = _onboardingData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Text(
                        item["badge"]!,
                        style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item["title"]!,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.black, height: 1.2),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item["subtitle"]!,
                      style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _proceedToApp,
              child: const Text('Explore Feed ➔', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
          ),

          // Bottom Navigation Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.amber : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Primary CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
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

              // Google Auth Button
              _buildSocialAuthButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continue with Google',
                bgColor: Colors.white,
                textColor: Colors.black,
                onTap: () {
                  Navigator.pop(context);
                  _proceedToApp();
                },
              ),
              const SizedBox(height: 12),

              // Facebook Auth Button
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

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ),
                  Expanded(child: Divider(color: Colors.white12)),
                ],
              ),
              const SizedBox(height: 20),

              // Phone Number Minimal Trigger
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _proceedToApp();
                },
                icon: const Icon(Icons.phone_android, color: Colors.amber),
                label: const Text('Use Phone Number & OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
