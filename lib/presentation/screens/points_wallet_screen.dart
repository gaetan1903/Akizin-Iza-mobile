import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';
import '../../core/colors.dart';

class PointsWalletScreen extends StatelessWidget {
  const PointsWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final points = 30; // mock
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Points')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solde actuel', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DT.s2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: DT.s5, vertical: DT.s4),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.primaryWhite),
                    borderRadius: BorderRadius.circular(DT.rMd),
                    border: Border.all(color: const Color(0xFFF1F1F3)),
                  ),
                  child: Text('$points points', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: DT.s4),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('RECHARGER'),
                ),
              ],
            ),
            const SizedBox(height: DT.s6),
            Text('Historique des transactions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DT.s3),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: DT.s2),
                itemBuilder: (ctx, i) => Container(
                  padding: const EdgeInsets.all(DT.s4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DT.rSm),
                    boxShadow: DT.shadowSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Consultation relation'),
                      Row(children: const [Icon(Icons.remove, color: Colors.red, size: 16), Text('-10')]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
