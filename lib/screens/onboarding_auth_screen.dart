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
  int _tipAmount = 9;

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
          content: Text('Welcome, ${userData["name"]}! 🚀', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );
      _proceedToApp();
    }
  }

  void _simulateLiveTip() {
    setState(() {
      _tipAmount += 10;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.greenAccent,
        content: Text('⚡ Instant ₹$_tipAmount Tip sent to @Aria_AI!', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Branding: "Vybe" Only
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 10),
                          ],
                        ),
                        child: const Icon(Icons.bolt, color: Colors.black, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vybe', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('AI Reels & Live Studio', style: TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _proceedToApp,
                    child: const Text('Explore Feed ➔', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // Live Creator Counter Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                            SizedBox(width: 6),
                            Text('1,420 Active Creators Online', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Primary Taglines
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: "Every Swipe Sparks Something.\n", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.2)),
                            TextSpan(text: "Create Smarter. Earn Faster. ", style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.w900, height: 1.2)),
                            TextSpan(text: "⚡", style: TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Generate autonomous short reels, host live streams & get direct UPI tips from 1000+ active creators.",
                        style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                      ),
                      const SizedBox(height: 16),

                      // Main Hero Container (FULL PHOTO LEFT - NO CIRCLE)
                      Container(
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber.withOpacity(0.18), const Color(0xFF141414)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.amber.withOpacity(0.35)),
                        ),
                        child: Row(
                          children: [
                            // Left Side: FULL High Quality Indian AI Girl Photo (Circle Removed!)
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.amber.withOpacity(0.6), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 10),
                                  ],
                                  image: const DecorationImage(
                                    image: NetworkImage('https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm00OTQtYmctMDA1YS14LmpwZw.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Gradient Overlay at Bottom for Text Visibility
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                                          gradient: LinearGradient(
                                            colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Text('Namaste! 🙏', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text('@Aria_AI • Creator', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Right Side: Live Stream Tipping Mockup
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white24, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(color: Colors.amber.withOpacity(0.12), blurRadius: 10),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Vybe Live', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                                            child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                      const Icon(Icons.play_circle_fill_rounded, color: Colors.amber, size: 38),
                                      GestureDetector(
                                        onTap: _simulateLiveTip,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 7),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 8),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text('Send ₹$_tipAmount Tip ⚡', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Feature Badges
                      Row(
                        children: [
                          Expanded(child: _buildBadgeItem(Icons.monetization_on_outlined, "Earn in Minutes")),
                          const SizedBox(width: 8),
                          Expanded(child: _buildBadgeItem(Icons.groups_outlined, "Real Creators")),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildBadgeItem(Icons.verified_user_outlined, "Safe & Secure")),
                          const SizedBox(width: 8),
                          Expanded(child: _buildBadgeItem(Icons.bolt_outlined, "Instant UPI")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
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
                  child: const Text('Start Earning & Create Now 🚀', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
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
