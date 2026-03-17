import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/image_urls.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../marketplace/domain/models/marketplace_listing.dart';
import '../../domain/models/vendor_listing_draft.dart';
import '../providers/vendor_dashboard_providers.dart';

class VendorListingEditorPage extends ConsumerStatefulWidget {
  const VendorListingEditorPage({
    this.listingId,
    super.key,
  });

  final String? listingId;

  @override
  ConsumerState<VendorListingEditorPage> createState() =>
      _VendorListingEditorPageState();
}

class _VendorListingEditorPageState
    extends ConsumerState<VendorListingEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _cityController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _vendorController;
  late final TextEditingController _cancellationController;
  MarketplaceCategory _category = MarketplaceCategory.hotel;

  @override
  void initState() {
    super.initState();
    final existingDraft = widget.listingId == null
        ? null
        : ref.read(vendorListingsProvider.notifier).findById(widget.listingId!);
    _category = existingDraft?.category ?? MarketplaceCategory.hotel;
    _titleController = TextEditingController(text: existingDraft?.title);
    _cityController = TextEditingController(text: existingDraft?.city);
    _locationController = TextEditingController(text: existingDraft?.location);
    _descriptionController =
        TextEditingController(text: existingDraft?.description);
    _priceController = TextEditingController(
      text: existingDraft?.price.toStringAsFixed(0),
    );
    _vendorController = TextEditingController(
      text: existingDraft?.vendorName ?? 'Discover Egypt Partner',
    );
    _cancellationController = TextEditingController(
      text: existingDraft?.cancellationPolicy ??
          'Free cancellation up to 48 hours before arrival.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _vendorController.dispose();
    _cancellationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.listingId == null ? 'New listing' : 'Edit listing',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<MarketplaceCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: MarketplaceCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _vendorController,
              decoration: const InputDecoration(labelText: 'Vendor name'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cancellationController,
              minLines: 2,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: 'Cancellation policy'),
              validator: _required,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveDraft,
              child: const Text('Save listing'),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existingDraft = widget.listingId == null
        ? null
        : ref.read(vendorListingsProvider.notifier).findById(widget.listingId!);
    final draft = VendorListingDraft(
      id: existingDraft?.id ?? '',
      category: _category,
      title: _titleController.text.trim(),
      city: _cityController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      vendorName: _vendorController.text.trim(),
      cancellationPolicy: _cancellationController.text.trim(),
      images: existingDraft?.images ?? _defaultImagesFor(_category),
      tags: existingDraft?.tags ?? <String>[_category.label],
      status: existingDraft?.status ?? VendorListingStatus.draft,
      createdAt: existingDraft?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(vendorListingsProvider.notifier).saveDraft(draft);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  List<String> _defaultImagesFor(MarketplaceCategory category) {
    switch (category) {
      case MarketplaceCategory.hotel:
        return const <String>[Img.hotelLuxury];
      case MarketplaceCategory.apartment:
        return const <String>[Img.hotelRoom];
      case MarketplaceCategory.tour:
        return const <String>[Img.pyramidsMain];
      case MarketplaceCategory.car:
        return const <String>[Img.carLuxury];
      case MarketplaceCategory.guide:
        return const <String>[Img.avatarWoman];
      case MarketplaceCategory.attraction:
        return const <String>[Img.abuSimbel];
      case MarketplaceCategory.restaurant:
        return const <String>[Img.restaurant];
    }
  }
}
