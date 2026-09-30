import 'package:flutter/material.dart';
import '../models/coin.dart';

class EditCoinScreen extends StatefulWidget {
  final Coin? coin;
  const EditCoinScreen({super.key, this.coin});
  @override
  State<EditCoinScreen> createState() => _EditCoinScreenState();
}

class _EditCoinScreenState extends State<EditCoinScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController rateCtrl;
  late TextEditingController curCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.coin?.name ?? '');
    rateCtrl = TextEditingController(
        text: widget.coin?.rate.toString() ?? '');
    curCtrl = TextEditingController(text: widget.coin?.currency ?? 'BDT');
  }

  void _save() {
    final name = nameCtrl.text.trim();
    final rate = double.tryParse(rateCtrl.text.trim()) ?? 0;
    final cur = curCtrl.text.trim().isEmpty ? 'BDT' : curCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কয়েনের নাম দিন')),
      );
      return;
    }
    final c = Coin(
      id: widget.coin?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      rate: rate,
      currency: cur,
      updatedAt: DateTime.now(),
    );
    Navigator.pop(context, c);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.coin != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Coin' : 'Add Coin')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Coin Name (e.g. NS Coin)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Rate (e.g. 8)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: curCtrl,
              decoration: const InputDecoration(
                labelText: 'Currency (BDT)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEdit ? 'Update' : 'Save',
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
