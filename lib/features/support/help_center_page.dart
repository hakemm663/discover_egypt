import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help Center',
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Help center tools will be connected in a future backend release. Coming soon.',
        ),
      ),
    );
  }
}
