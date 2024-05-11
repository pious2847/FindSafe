import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AboutPhone extends StatefulWidget {
  const AboutPhone({super.key});

  @override
  State<AboutPhone> createState() => _AboutPhoneState();
}

class _AboutPhoneState extends State<AboutPhone> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('About', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
      ),
 body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _CustomListTile(
                title: 'AppName',
                subtitle: 'FindSafe',
              ),
              // _AppNameAndLogo(),
              // SizedBox(height: 16),
              _CustomListTile(
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _CustomListTile(
                title: 'Description',
                subtitle: 'This is a brief description of your app, its purpose, and key features.',
              ),
              _CustomListTile(
                title: 'Developer',
                subtitle: 'Developed by Your Name or Company\nContact: yourname@example.com',
              ),
              _CustomListTile(
                title: 'Privacy Policy',
                subtitle: 'Link to your privacy policy',
              ),
              SizedBox(height: 16),
              // _SocialMediaLinks(),
            ],
          ),
        ),
      ),
    );
  }

  // ... (other widget methods)
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  _CustomListTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Divider(
          thickness: 1,
          height: 0,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}