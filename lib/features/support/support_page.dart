import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_app_bar.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key});

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _submitting = false;
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _loadConnectivity();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((event) async {
      final offline = event.every((entry) => entry == ConnectivityResult.none);
      if (!mounted) return;
      setState(() => _isOffline = offline);
      if (!offline) {
        await _flushQueuedTickets();
      }
    });
  }

  Future<void> _loadConnectivity() async {
    final status = await Connectivity().checkConnectivity();
    if (!mounted) return;
    setState(() {
      _isOffline = status.every((entry) => entry == ConnectivityResult.none);
    });
    if (!_isOffline) {
      await _flushQueuedTickets();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  Future<void> _launchChannel(Uri uri, String fallback) async {
    if (_isOffline) {
      _showSnack('You are offline. Connect to the internet to open $fallback.');
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showSnack('Could not open $fallback on this device.');
    }
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final payload = {
      'subject': _subjectController.text.trim(),
      'message': _messageController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      if (_isOffline) {
        await _queueTicket(payload);
        _showSnack('You are offline. Ticket saved locally and will be sent when online.');
      } else {
        await _sendTicket(payload);
        _showSnack('Support ticket submitted successfully.');
      }

      _subjectController.clear();
      _messageController.clear();
    } catch (error) {
      _showSnack('Could not submit ticket: $error');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _sendTicket(Map<String, dynamic> payload) async {
    final user = ref.read(authServiceProvider).currentUser;

    await FirebaseFirestore.instance.collection('support_tickets').add({
      ...payload,
      'status': 'open',
      'userId': user?.uid,
      'email': user?.email,
      'source': 'mobile-app',
      'submittedAt': Timestamp.now(),
    });
  }

  Future<void> _queueTicket(Map<String, dynamic> payload) async {
    final box = Hive.box(AppConstants.settingsBox);
    final current = (box.get(AppConstants.supportTicketsQueueKey, defaultValue: []) as List)
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();

    current.add(payload);
    await box.put(AppConstants.supportTicketsQueueKey, current);
  }

  Future<void> _flushQueuedTickets() async {
    final box = Hive.box(AppConstants.settingsBox);
    final queued = (box.get(AppConstants.supportTicketsQueueKey, defaultValue: []) as List)
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();

    if (queued.isEmpty) return;

    final failed = <Map<String, dynamic>>[];
    for (final ticket in queued) {
      try {
        await _sendTicket(ticket);
      } catch (_) {
        failed.add(ticket);
      }
    }

    await box.put(AppConstants.supportTicketsQueueKey, failed);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Support',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_isOffline)
            Card(
              color: Colors.orange.shade50,
              child: const ListTile(
                leading: Icon(Icons.wifi_off_rounded),
                title: Text('Offline mode enabled'),
                subtitle: Text('You can draft a support ticket. It will sync once you reconnect.'),
              ),
            ),
          const SizedBox(height: 12),
          Text('Contact channels', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('support@discoveregypt.app'),
            subtitle: const Text('Email support (24 hours)'),
            onTap: () => _launchChannel(Uri.parse('mailto:support@discoveregypt.app'), 'email'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('+20 2 1234 5678'),
            subtitle: const Text('Phone support (09:00–18:00 EET)'),
            onTap: () => _launchChannel(Uri.parse('tel:+20212345678'), 'phone support'),
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('WhatsApp quick help'),
            subtitle: const Text('Fast responses for booking issues'),
            onTap: () =>
                _launchChannel(Uri.parse('https://wa.me/201001234567'), 'WhatsApp support'),
          ),
          const Divider(height: 30),
          Text('Frequently asked questions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('Booking changes'),
                onPressed: () => context.push('/help-center?topic=booking'),
              ),
              ActionChip(
                label: const Text('Payments and refunds'),
                onPressed: () => context.push('/help-center?topic=payment'),
              ),
              ActionChip(
                label: const Text('Account and security'),
                onPressed: () => context.push('/help-center?topic=account'),
              ),
            ],
          ),
          const Divider(height: 30),
          Text('Submit a ticket', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Subject is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'How can we help?',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 20) {
                      return 'Please provide at least 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submitting ? null : _submitTicket,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(_isOffline ? 'Save ticket offline' : 'Submit ticket'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
