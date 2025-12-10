import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';
import '../../core/colors.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> plans = [
      {
        'name': 'Standard',
        'price': 'Gratuit',
        'desc': 'Payez 10 points par consultation de relation.',
        'features': <String>['Accès code utilisateur', 'Recherche par nom', 'Consultation payante'],
      },
      {
        'name': 'Premium',
        'price': '9.99€/mois',
        'desc': 'Consultations illimitées sans dépenser de points.',
        'features': <String>['Tout Standard', 'Consultations illimitées', 'Priorité support'],
      }
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Abonnements')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choisissez un abonnement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: DT.s5),
            Expanded(
              child: ListView.separated(
                itemCount: plans.length,
                separatorBuilder: (_, __) => const SizedBox(height: DT.s5),
                itemBuilder: (ctx, i) {
                  final Map<String, Object> p = plans[i];
                  final isPremium = p['name'] == 'Premium';
                  return Container(
                    padding: const EdgeInsets.all(DT.s5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(DT.rMd),
                      boxShadow: DT.shadowSm,
                      border: Border.all(color: isPremium ? AppColors.primary : const Color(0xFFF1F1F3), width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(p['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            if (isPremium)
                              Container(
                                margin: const EdgeInsets.only(left: DT.s3),
                                padding: const EdgeInsets.symmetric(horizontal: DT.s3, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryWhite,
                                  borderRadius: BorderRadius.circular(DT.rFull),
                                ),
                                child: const Text('Populaire', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                        const SizedBox(height: DT.s2),
                        Text(p['price'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: DT.s3),
                        Text(p['desc'] as String, style: const TextStyle(fontSize: 14, height: 1.4)),
                        const SizedBox(height: DT.s4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (p['features'] as List<String>).map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: AppColors.green, size: 18),
                                    const SizedBox(width: DT.s2),
                                    Expanded(child: Text(f)),
                                  ],
                                ),
                              )).toList(),
                        ),
                        const SizedBox(height: DT.s5),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPremium ? AppColors.primary : AppColors.dark,
                            ),
                            child: Text(isPremium ? 'PASSER PREMIUM' : 'RESTER STANDARD'),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
