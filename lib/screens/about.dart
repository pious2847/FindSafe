import 'package:flutter/material.dart';

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
        title: const Text('About', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
      ),
 body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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

  const _CustomListTile({
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 14),
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