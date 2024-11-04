import 'package:flutter/material.dart';
import 'package:kindkarma/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    Color iconColor = Colors.blue,
  }) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(

        transform: Matrix4.translationValues(0, -20, 0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: () => _launchUrl(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Charitex',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Making the world better, one app at a time',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Our Mission'),
                    const Text(
                      'We strive to create innovative solutions that make people\'s lives easier and more enjoyable. Our commitment to excellence and user satisfaction drives everything we do.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    _buildSectionTitle('What We Offer'),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildInfoCard(
                          title: 'Innovation',
                          description: 'Cutting-edge solutions for modern problems',
                          icon: Icons.lightbulb_outline,
                          iconColor: Colors.orange,
                        ),
                        _buildInfoCard(
                          title: 'Security',
                          description: 'Your data safety is our top priority',
                          icon: Icons.security,
                          iconColor: Colors.green,
                        ),
                        _buildInfoCard(
                          title: 'Support',
                          description: '24/7 customer support for all your needs',
                          icon: Icons.headset_mic,
                          iconColor: Colors.purple,
                        ),
                        _buildInfoCard(
                          title: 'Quality',
                          description: 'High-quality products that you can trust',
                          icon: Icons.verified,
                          iconColor: Colors.blue,
                        ),
                      ],
                    ),
                    _buildSectionTitle('Our Team'),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildTeamMember(
                          name: 'Terfi Mohammed Wassim',
                          role: 'CEO & Founder',
                          imageUrl: 'https://via.placeholder.com/150',
                        ),
                        _buildTeamMember(
                          name: 'Terfi Mohammed Wassim',
                          role: 'Lead Developer',
                          imageUrl: 'https://via.placeholder.com/150',
                        ),
                      ],
                    ),
                    _buildSectionTitle('Contact Us'),
                    const ListTile(
                      leading: Icon(Icons.email, color: accentColor),
                      title: Text('Email'),
                      subtitle: Text('wassimou009@gmail.com'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone, color: accentColor),
                      title: Text('Phone'),
                      subtitle: Text('+33 783336571'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.location_on, color: accentColor),
                      title: Text('Address'),
                      subtitle: Text('123 Main Street\nCity, State 12345'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.facebook,
                          url: 'https://facebook.com',
                          color: Colors.blue,
                        ),
                        _buildSocialButton(
                          icon: Icons.telegram,
                          url: 'https://telegram.org',
                          color: Colors.blue,
                        ),
                        _buildSocialButton(
                          icon: Icons.phone,
                          url: 'https://whatsapp.com',
                          color: primaryGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}