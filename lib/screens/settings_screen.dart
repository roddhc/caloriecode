import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_colors.dart';
import '../utils/design_spacing.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignSpacing.md),
        children: [
          // 1. Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: DesignColors.getPrimaryBlue(context).withOpacity(0.2),
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.getPrimaryBlue(context),
                  ),
                ),
              ),
              const SizedBox(width: DesignSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Harrison',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: DesignColors.getTextColor(context),
                      ),
                    ),
                    Text(
                      'alex@example.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: DesignColors.getTextSecondaryColor(context),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: DesignColors.getPrimaryBlue(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSpacing.lg),

          // 2. Current Food Code Badge
          Container(
            padding: const EdgeInsets.all(DesignSpacing.md),
            decoration: BoxDecoration(
              color: DesignColors.getLightGray(context).withOpacity(0.5),
              borderRadius: BorderRadius.circular(DesignSpacing.radiusCard),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Food Code',
                      style: TextStyle(
                        fontSize: 12,
                        color: DesignColors.getTextSecondaryColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: DesignColors.getPrimaryBlue(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '🧬 KETO-VITAL-24',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: DesignColors.getPrimaryBlue(context),
                        ),
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DesignColors.getTextColor(context),
                    side: BorderSide(color: DesignColors.getLightGray(context)),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  child: const Text('Switch Code'),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSpacing.lg),

          // 3. General Section
          Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DesignColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            activeColor: DesignColors.getPrimaryBlue(context),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _isDarkMode = value;
              });
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notificationsEnabled,
            activeColor: DesignColors.getPrimaryBlue(context),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              items: ['English', 'Türkçe'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
          ),
          const SizedBox(height: DesignSpacing.md),

          // 4. Account Section
          Text(
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DesignColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: DesignSpacing.xxl,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: DesignColors.getPrimaryBlue(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSpacing.radiusButton),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
              },
              icon: const Icon(Icons.star),
              label: const Text('Upgrade to Premium - Unlimited scans + no ads', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          ListTile(
            title: Text(
              'Restore purchase',
              style: TextStyle(color: DesignColors.getPrimaryBlue(context)),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            dense: true,
          ),
          ListTile(
            title: Text(
              'Manage subscription',
              style: TextStyle(color: DesignColors.getPrimaryBlue(context)),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            dense: true,
          ),
          const Divider(),

          // 5. Legal Section
          Text(
            'Legal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DesignColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          _buildLinkItem('Privacy Policy'),
          _buildLinkItem('Terms of Service'),
          _buildLinkItem('Medical Disclaimer'),
          _buildLinkItem('Open Source Licenses'),
          const Divider(),

          // 6. About Section
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DesignColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          ListTile(
            title: const Text('Version 1.0.0'),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Send feedback'),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate on App Store'),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            dense: true,
          ),
          const SizedBox(height: DesignSpacing.lg),

          Center(
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: DesignColors.getDangerRed(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: DesignSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: DesignColors.getPrimaryBlue(context),
          decoration: TextDecoration.underline,
          decorationColor: DesignColors.getPrimaryBlue(context),
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
      },
      dense: true,
    );
  }
}
