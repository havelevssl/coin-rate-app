class Coin {
  final String id;
  String name;
  double rate;
  String currency;
  DateTime updatedAt;

  Coin({
    required this.id,
    required this.name,
    required this.rate,
    this.currency = 'BDT',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rate': rate,
        'currency': currency,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Coin.fromJson(Map<String, dynamic> j) => Coin(
        id: j['id'],
        name: j['name'],
        rate: (j['rate'] as num).toDouble(),
        currency: j['currency'] ?? 'BDT',
        updatedAt: DateTime.parse(j['updatedAt']),
      );
}
