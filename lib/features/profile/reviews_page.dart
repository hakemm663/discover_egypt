import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/models/review_model.dart';
import '../../core/widgets/custom_app_bar.dart';

final myReviewsProvider = StreamProvider.autoDispose<List<ReviewModel>>((ref) {
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) {
    return Stream.value(const []);
  }

  return ref.watch(databaseServiceProvider).watchUserReviews(user.uid);
});

class ReviewsPage extends ConsumerWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(myReviewsProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Reviews',
        showBackButton: true,
      ),
      body: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 40),
                const SizedBox(height: 8),
                const Text('Could not load your reviews.'),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => ref.invalidate(myReviewsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (reviews) {
          if (reviews.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No reviews yet. Once you review a hotel, tour, car, or restaurant, it will appear here.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) => _ReviewTile(review: reviews[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: reviews.length,
          );
        },
      ),
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  const _ReviewTile({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final canManage = authService.currentUser?.uid == review.userId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  review.itemType.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.round() ? Icons.star : Icons.star_border,
                    size: 18,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(review.comment),
            const SizedBox(height: 8),
            Text(
              'Posted on ${review.createdAt.toLocal().toString().split(' ').first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (canManage)
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEditDialog(context, ref, review),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDelete(context, ref, review),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    ReviewModel review,
  ) async {
    final formKey = GlobalKey<FormState>();
    final commentController = TextEditingController(text: review.comment);
    double rating = review.rating;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit review'),
        content: StatefulBuilder(
          builder: (context, setState) => Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Rating'),
                    Expanded(
                      child: Slider(
                        value: rating,
                        min: 1,
                        max: 5,
                        divisions: 8,
                        label: rating.toStringAsFixed(1),
                        onChanged: (value) => setState(() => rating = value),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: commentController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return 'Please write at least 5 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final userId = ref.read(authServiceProvider).currentUser?.uid;
              if (userId == null) return;

              await ref.read(databaseServiceProvider).updateReview(
                    reviewId: review.id,
                    userId: userId,
                    rating: rating,
                    comment: commentController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Review updated.')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    commentController.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ReviewModel review,
  ) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete review?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId == null) return;

    await ref.read(databaseServiceProvider).deleteReview(
          reviewId: review.id,
          userId: userId,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Review deleted.')));
    }
  }
}
