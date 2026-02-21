import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Support',
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Live support chat is coming soon. Please check back in an upcoming update.',
        ),
      ),
    );
  }
}
