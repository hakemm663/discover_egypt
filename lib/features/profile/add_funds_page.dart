import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class AddFundsPage extends StatelessWidget {
  const AddFundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Funds',
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Wallet top-ups are coming soon after payment backend integration.',
        ),
      ),
    );
  }
}
