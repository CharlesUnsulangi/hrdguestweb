import 'package:flutter/material.dart';

import '../utils/safe_run.dart';
import '../utils/validators.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final ok = await safeAsync<bool>(() async {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }, timeout: const Duration(seconds: 10));

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesan terkirim')));
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => isNotEmpty(v) ? null : 'Nama kosong',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                looksLikeEmail(v)
                    ? null
                    : 'Email tidak valid',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Pesan'),
                maxLines: 4,
                validator: (v) => isNotEmpty(v) ? null : 'Pesan kosong',
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: _submit, child: const Text('Kirim')),
            ],
          ),
        ),
      ),
    );
  }
}
