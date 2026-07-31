import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../main.dart';

class OnboardingAuthScreen extends StatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  State<OnboardingAuthScreen> createState() => _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends State<OnboardingAuthScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glow Orbs
          Positioned(
            top: -50,
            left: screenSize.width * 0.1,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.amber.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.withOpacity(0.5)),
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
                  const SizedBox(height: 16),

                  // Center Card: AI Girl Creator Hero Section
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.withOpacity(0.18), const Color(0xFF141414)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.amber.withOpacity(0.35), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated Pulse Ring
                          ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.08).animate(_pulseController),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.amber.withOpacity(0.4), width: 1.5),
                              ),
                            ),
                          ),

                          // Creator Avatar & Welcome Tag
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 105,
                                height: 105,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Colors.amber, Colors.orangeAccent],
                                  ),
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 15),
                                  ],
                                ),
                                child: const Center(
                                  child: Text('🥻', style: TextStyle(fontSize: 50)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.amber),
                                ),
                                child: const Text(
                                  'Namaste! 🙏 Welcome to Vybe',
                                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '@Aria_AI • Digital Influencer',
                                style: TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),

                          // Instant UPI Badge
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.greenAccent.withOpacity(0.6)),
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
                  const SizedBox(height: 20),

                  // Features Grid Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem("1.2M+", "AI Reels"),
                      _buildMetricItem("4.9 ★", "Top Rated"),
                      _buildMetricItem("⚡ Instant", "UPI Payouts"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Main Headline
                  const Text(
                    "Next-Gen AI Reels & Live Studio",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Generate autonomous videos, receive direct creator tips & join 1000+ interactive live streams.",
                    style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Call To Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        elevation: 8,
                        shadowColor: Colors.amber.withOpacity(0.4),
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

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
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
              const SizedBox(height: 18),

              const Text(
                'By continuing, you agree to Vybe Terms of Service & Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
              const SizedBox(height: 10),
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
