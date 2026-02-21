import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Terms of Service',
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Terms of service are coming soon while legal copy is being prepared.',
        ),
      ),
    );
  }
}
