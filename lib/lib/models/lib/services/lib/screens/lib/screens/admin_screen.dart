import 'package:flutter/material.dart';
import '../models/coin.dart';
import '../services/storage_service.dart';
import 'edit_coin_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Coin> coins = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    coins = await StorageService.loadCoins();
    setState(() {});
  }

  Future<void> _save() async {
    await StorageService.saveCoins(coins);
  }

  Future<void> _addOrEdit([Coin? coin]) async {
    final result = await Navigator.push<Coin>(
      context,
      MaterialPageRoute(builder: (_) => EditCoinScreen(coin: coin)),
    );
    if (result == null) return;
    setState(() {
      if (coin == null) {
        coins.add(result);
      } else {
        final i = coins.indexWhere((c) => c.id == coin.id);
        if (i != -1) coins[i] = result;
      }
    });
    await _save();
  }

  Future<void> _delete(Coin c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2E),
        title: const Text('Delete?'),
        content: Text('${c.name} ডিলিট করতে চান?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes')),
        ],
      ),
    );
    if (ok == true) {
      setState(() => coins.removeWhere((x) => x.id == c.id));
      await _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Admin Panel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEdit(),
        icon: const Icon(Icons.add),
        label: const Text('Add Coin'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coins.length,
        itemBuilder: (_, i) {
          final c = coins[i];
          return Card(
            color: const Color(0xFF1A1D2E),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(c.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${c.rate} ${c.currency}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _addOrEdit(c),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _delete(c),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
