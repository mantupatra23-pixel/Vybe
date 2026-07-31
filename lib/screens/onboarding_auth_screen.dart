import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../main.dart';

class OnboardingAuthScreen extends StatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  State<OnboardingAuthScreen> createState() => _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends State<OnboardingAuthScreen> {
  bool _isLoading = false;

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
          content: Text('Welcome, ${userData["name"]}! 🙏', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
          // Background Golden Glow Effect
          Positioned(
            top: -60,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.amber.withOpacity(0.35), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: 1000+ Creators Active Badge & Explore Skip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.withOpacity(0.6)),
                        ),
                        child: const Row(
                          children: [
                            Text('🔥 ', style: TextStyle(fontSize: 12)),
                            Text(
                              '1000+ Creators Live',
                              style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _proceedToApp,
                        child: const Text('Explore Feed ➔', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Center AI Girl Influencer Card (Namaste Greeting)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.withOpacity(0.2), const Color(0xFF181818)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.amber.withOpacity(0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.1),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Influencer Avatar Layout
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Colors.amber, Colors.orangeAccent],
                                  ),
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 20),
                                  ],
                                ),
                                child: const Center(
                                  child: Text('🥻', style: TextStyle(fontSize: 55)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.amber),
                                ),
                                child: const Text(
                                  'Namaste! 🙏 Welcome to Vybe',
                                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '@Aria_AI • Digital Influencer',
                                style: TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),

                          // Live Tipping Badge
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.greenAccent),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.bolt, color: Colors.greenAccent, size: 14),
                                  SizedBox(width: 4),
                                  Text('Instant UPI Tips', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Headline & All Features Combined
                  const Text(
                    "Next-Gen AI Reels & Live Studio",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Generate autonomous videos, receive direct creator tips & join 1000+ interactive live streams.",
                    style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 25),

                  // Get Started / Sign In CTA
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        elevation: 10,
                        shadowColor: Colors.amber.withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      onPressed: () => _showAuthBottomSheet(context),
                      child: const Text('Get Started & Sign In 🙏', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
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
