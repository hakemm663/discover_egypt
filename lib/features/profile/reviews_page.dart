import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Reviews',
        showBackButton: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Review history integration is coming soon. You will be able to manage reviews here.',
        ),
      ),
    );
  }
}
