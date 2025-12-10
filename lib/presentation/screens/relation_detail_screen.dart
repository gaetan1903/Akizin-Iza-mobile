import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';
import '../../core/colors.dart';

class RelationDetailScreen extends StatelessWidget {
  const RelationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder relation detail UI
    return Scaffold(
      appBar: AppBar(title: const Text('Détail Relation')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(DT.s5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DT.rMd),
                boxShadow: DT.shadowSm,
              ),
              child: Row(
                children: const [
                  Icon(Icons.favorite, color: AppColors.primary, size: 30),
                  SizedBox(width: DT.s4),
                  Expanded(
                    child: Text('Paul est en couple avec Clara depuis 2022.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DT.s6),
            const Text('Historique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: DT.s3),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: DT.s2),
                itemBuilder: (ctx, i) => Container(
                  padding: const EdgeInsets.all(DT.s4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(DT.rSm),
                    border: Border.all(color: const Color(0xFFF1F1F3)),
                  ),
                  child: Text('Événement ${i + 1}: changement statut / mise à jour.'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
