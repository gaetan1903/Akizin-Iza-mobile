import 'package:flutter/material.dart';
import '../../core/design_tokens.dart';
import '../../core/colors.dart';

class SearchNameScreen extends StatefulWidget {
  const SearchNameScreen({super.key});
  @override
  State<SearchNameScreen> createState() => _SearchNameScreenState();
}

class _SearchNameScreenState extends State<SearchNameScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _profileLoaded = false;
  bool _relationVisible = false;
  int _points = 25; // mock user points

  void _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() { _loading = true; _profileLoaded = false; _relationVisible = false; });
    await Future.delayed(DT.dBase);
    setState(() { _loading = false; _profileLoaded = true; });
  }

  void _showRelation() {
    if (_relationVisible) return;
    if (_points < 10) {
      _showDialog('Solde insuffisant', 'Rechargez vos points pour consulter la relation.');
      return;
    }
    setState(() { _points -= 10; _relationVisible = true; });
  }

  void _showDialog(String title, String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche Nom')),
      body: Padding(
        padding: const EdgeInsets.all(DT.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nom / Prénom',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(DT.rSm)),
                    ),
                  ),
                ),
                const SizedBox(width: DT.s3),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  child: _loading ? const SizedBox(height:18,width:18,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Text('CHERCHER'),
                ),
              ],
            ),
            const SizedBox(height: DT.s5),
            Text('Points: $_points', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: DT.s5),
            if (_profileLoaded) _buildProfileCard(),
            if (_profileLoaded && !_relationVisible)
              Padding(
                padding: const EdgeInsets.only(top: DT.s4),
                child: ElevatedButton(
                  onPressed: _showRelation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DT.rFull)),
                  ),
                  child: const Text('VOIR LA RELATION (10 points)'),
                ),
              ),
            if (_relationVisible) _buildRelationDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DT.s5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DT.rMd),
        boxShadow: DT.shadowSm,
        border: Border.all(color: const Color(0xFFF1F1F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Profil trouvé', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: DT.s2),
          Text('Nom: Jean'),
          Text('Prénom: Paul'),
          Text('Date de naissance: 12/04/1999'),
        ],
      ),
    );
  }

  Widget _buildRelationDetail() {
    return AnimatedContainer(
      duration: DT.dFast,
      margin: const EdgeInsets.only(top: DT.s5),
      padding: const EdgeInsets.all(DT.s5),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(DT.rMd),
        border: Border.all(color: const Color(0xFFF1F1F3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.favorite, color: AppColors.primary),
          SizedBox(width: DT.s3),
          Expanded(
            child: Text('Jean est en couple avec Marie depuis 2023.'),
          ),
        ],
      ),
    );
  }
}
