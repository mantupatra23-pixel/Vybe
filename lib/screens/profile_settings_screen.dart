import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'ai_studio_screen.dart';
import 'boost_screen.dart';
import 'verification_screen.dart';
import 'privacy_screen.dart';
import 'live_apply_screen.dart';
import 'leaderboard_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Profile Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Account'),
          _buildSettingTile(context, Icons.rocket_launch, 'Vybe Boost', 'Boost your posts and get viral', Colors.amber, const BoostScreen()),
          _buildSettingTile(context, Icons.workspace_premium, 'Join Vybe VIP (\$1/mo)', 'Zero ads & high quality AI rendering', Colors.amber, null),
          _buildSettingTile(context, Icons.psychology, 'AI Creator Tools', 'Access Groq script studio & analytics', Colors.blue, const AiStudioScreen()),
          _buildSettingTile(context, Icons.verified_user, 'Get Blue Verification Badge', 'Verify account identity', Colors.green, const VerificationScreen()),
          _buildSettingTile(context, Icons.lock_outline, 'Privacy Settings', 'Manage account visibility', Colors.white70, const PrivacyScreen()),
          _buildSettingTile(context, Icons.account_balance_wallet, 'Vybe Wallet & Tips', 'Withdraw tip earnings directly', Colors.amber, const WalletScreen()),

          const Divider(color: Colors.white12, height: 30),
          _buildSectionTitle('Live & Gamification'),
          _buildSettingTile(context, Icons.sensors, 'Apply for Vybe Live', 'Start streaming to millions', Colors.redAccent, const LiveApplyScreen()),
          _buildSettingTile(context, Icons.emoji_events, 'Live Creator Leaderboard', 'Check top earners this week', Colors.amber, const LeaderboardScreen()),

          const SizedBox(height: 20),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out of all devices...')),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text('Logout All Devices', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String subtitle, Color iconColor, Widget? targetScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
        onTap: () {
          if (targetScreen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening $title...')),
            );
          }
        },
      ),
    );
  }
}
