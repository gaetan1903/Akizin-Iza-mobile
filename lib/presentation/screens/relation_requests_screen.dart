import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';

class RelationRequestsScreen extends StatelessWidget {
  const RelationRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      {'from': 'Alice', 'status': 'en attente'},
      {'from': 'Marc', 'status': 'en attente'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Demandes de relation')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: ListView.separated(
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: DT.s3),
          itemBuilder: (ctx, i) {
            final r = requests[i];
            return Container(
              padding: const EdgeInsets.all(DT.s4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DT.rSm),
                boxShadow: DT.shadowSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Demande de ${r['from']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(r['status'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Refuser')),
                  ElevatedButton(onPressed: () {}, child: const Text('Accepter')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
