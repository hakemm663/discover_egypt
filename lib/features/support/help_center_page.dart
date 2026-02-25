import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key, this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context) {
    final selectedTopic = topic ?? Uri.base.queryParameters['topic'];

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help Center',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (selectedTopic != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.push_pin_outlined),
                title: Text('Showing FAQs for "$selectedTopic"'),
                subtitle: const Text('Tap another section for more topics.'),
              ),
            ),
          ExpansionTile(
            initiallyExpanded: selectedTopic == 'booking',
            title: const Text('Booking changes'),
            children: const [
              ListTile(title: Text('How can I modify a confirmed booking?')),
              ListTile(title: Text('Can I cancel after free-cancellation ends?')),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: selectedTopic == 'payment',
            title: const Text('Payments and refunds'),
            children: const [
              ListTile(title: Text('When will my refund appear?')),
              ListTile(title: Text('Which payment methods are accepted?')),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: selectedTopic == 'account',
            title: const Text('Account and security'),
            children: const [
              ListTile(title: Text('How do I reset my password?')),
              ListTile(title: Text('How do I update my country and language?')),
            ],
          ),
        ],
      ),
    );
  }
}
