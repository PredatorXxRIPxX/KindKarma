import 'package:flutter/material.dart';
import 'package:kindkarma/utils/utility.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
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
          'Terms & Conditions',
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
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.description_outlined,
                    size: 48,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildParagraph(
                  'Please read these Terms and Conditions carefully before using our application. By accessing or using the application, you agree to be bound by these Terms and Conditions.',
                ),
                _buildSectionTitle('1. Acceptance of Terms'),
                _buildParagraph(
                  'By accessing and using this application, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use our application.',
                ),
                _buildSectionTitle('2. User Account'),
                _buildBulletPoint(
                  'You are responsible for maintaining the confidentiality of your account credentials.',
                ),
                _buildBulletPoint(
                  'You agree to provide accurate and complete information when creating an account.',
                ),
                _buildBulletPoint(
                  'You must immediately notify us of any unauthorized use of your account.',
                ),
                _buildSectionTitle('3. Privacy Policy'),
                _buildParagraph(
                  'Our Privacy Policy describes how we handle the information you provide to us when you use our application. By using our application, you agree that we can use such information in accordance with our Privacy Policy.',
                ),
                _buildSectionTitle('4. Intellectual Property'),
                _buildParagraph(
                  'The application and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
                ),
                _buildSectionTitle('5. User Content'),
                _buildBulletPoint(
                  'You retain all rights to any content you submit, post or display on or through the application.',
                ),
                _buildBulletPoint(
                  'By posting content, you grant us a license to use, modify, publicly perform, publicly display, reproduce, and distribute such content.',
                ),
                _buildSectionTitle('6. Prohibited Uses'),
                _buildParagraph(
                  'You agree not to use the application:',
                ),
                _buildBulletPoint(
                  'In any way that violates any applicable national or international law or regulation.',
                ),
                _buildBulletPoint(
                  'To transmit, or procure the sending of, any advertising or promotional material without our prior written consent.',
                ),
                _buildBulletPoint(
                  'To impersonate or attempt to impersonate other users or any other person or entity.',
                ),
                _buildSectionTitle('7. Termination'),
                _buildParagraph(
                  'We may terminate or suspend your account and bar access to the application immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.',
                ),
                _buildSectionTitle('8. Changes to Terms'),
                _buildParagraph(
                  'We reserve the right to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms on the application. Your continued use of the application after any such changes constitutes your acceptance of the new Terms.',
                ),
                _buildSectionTitle('9. Contact Us'),
                _buildParagraph(
                  'If you have any questions about these Terms, please contact us at:',
                ),
                _buildParagraph(
                  'Email: support@example.com\nPhone: +1 (555) 123-4567\nAddress: 123 Main Street, City, Country',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'I Understand and Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}