import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Katalog verisini `assets/data/products.json` dosyasından okur.
///
/// Gün 4 konusu: JSON simülasyonundan veri okuma. Gerçek bir API çağrısı yerine
/// asset dosyası kullanılır; böylece ek paket gerekmeden aynı akış öğrenilir.
class ProductService {
  static const String _assetPath = 'assets/data/products.json';

  List<Product> _products = const [];
  List<String> _categories = const [];

  List<Product> get products => _products;
  List<String> get categories => _categories;

  /// Asset dosyasını okur, çözümler ve modele dönüştürür.
  Future<void> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;

    _categories = List<String>.from(data['categories'] as List);
    _products = (data['products'] as List)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Kategoriye göre filtreleme. "Tümü" seçiliyse tüm liste döner.
  List<Product> byCategory(String category) {
    if (category == 'Tümü') return _products;
    return _products.where((p) => p.category == category).toList();
  }

  /// Ürün adı ve kategoride basit arama (Gün 4: arama ve filtreleme mantığı).
  List<Product> search(String keyword, {String category = 'Tümü'}) {
    final needle = keyword.trim().toLowerCase();
    final base = byCategory(category);

    if (needle.isEmpty) return base;

    return base
        .where((p) =>
            p.name.toLowerCase().contains(needle) ||
            p.category.toLowerCase().contains(needle))
        .toList();
  }

  /// Ana sayfada gösterilecek öne çıkan ürünler.
  ///
  /// Vitrinde aynı kategoriden ürünlerin üst üste gelmemesi için önce her
  /// kategorinin en yüksek puanlı ürünü seçilir, ardından puana göre ilk 4
  /// ürün alınır.
  List<Product> get featured {
    final bestOfCategory = <String, Product>{};

    for (final product in _products) {
      final current = bestOfCategory[product.category];
      if (current == null || product.rating > current.rating) {
        bestOfCategory[product.category] = product;
      }
    }

    final sorted = bestOfCategory.values.toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(4).toList();
  }
}
