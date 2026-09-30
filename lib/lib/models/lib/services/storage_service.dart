import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coin.dart';

class StorageService {
  static const _key = 'coins_data';

  static Future<List<Coin>> loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      // Default demo data
      final demo = [
        Coin(id: '1', name: 'NS Coin', rate: 8.0),
        Coin(id: '2', name: 'Top Follow', rate: 4.5),
      ];
      await saveCoins(demo);
      return demo;
    }
    final List list = jsonDecode(raw);
    return list.map((e) => Coin.fromJson(e)).toList();
  }

  static Future<void> saveCoins(List<Coin> coins) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(coins.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
