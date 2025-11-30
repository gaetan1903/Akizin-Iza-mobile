import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _phoneController = TextEditingController();
  final _cinController = TextEditingController();
  bool _submitting = false;

  void _submit() async {
    if (_phoneController.text.isEmpty || _cinController.text.isEmpty) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _submitting = false);
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Envoyé'),
          content: const Text('Votre demande de vérification a été soumise.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification du compte')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Soumettre CIN et téléphone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: DT.s5),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
            ),
            const SizedBox(height: DT.s4),
            TextField(
              controller: _cinController,
              decoration: const InputDecoration(labelText: 'CIN', border: OutlineInputBorder()),
            ),
            const SizedBox(height: DT.s4),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('SOUMETTRE'),
            ),
          ],
        ),
      ),
    );
  }
}
