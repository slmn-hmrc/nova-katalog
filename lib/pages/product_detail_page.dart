import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../widgets/cart_button.dart';

/// ÜRÜN DETAY EKRANI
///
/// Gün 3 konusu: Sayfalar arası veri taşıma. Ürün nesnesi Route Arguments
/// aracılığıyla bu sayfaya iletilir.
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  void _addToCart(BuildContext context) {
    CartService.instance.add(product);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Sepete git',
            onPressed: () => Navigator.pushNamed(context, '/sepet'),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Ürün görseli
          AspectRatio(
            aspectRatio: 1.55,
            child: Container(
              color: Colors.white,
              child: Image.asset(product.image, fit: BoxFit.contain),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),

                // Puan ve stok bilgisi
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Color(0xFFF0803C)),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.isLowStock
                            ? const Color(0xFFFDEBE6)
                            : const Color(0xFFE7F1EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.stockLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: product.isLowStock
                              ? const Color(0xFFC2452A)
                              : const Color(0xFF2F6B4C),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Text(
                  product.priceLabel,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2B3A),
                  ),
                ),

                const SizedBox(height: 22),
                const Text(
                  'Açıklama',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Color(0xFF4A5560),
                  ),
                ),

                const SizedBox(height: 22),
                const Text(
                  'Özellikler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _buildSpecTable(),
              ],
            ),
          ),
        ],
      ),

      // Sepete ekle butonu — basit state güncelleme (Gün 5)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed:
                  product.stock == 0 ? null : () => _addToCart(context),
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(
                product.stock == 0 ? 'Stokta yok' : 'Sepete ekle',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Özellik tablosu — JSON'daki `specs` haritasından üretilir.
  Widget _buildSpecTable() {
    final entries = product.specs.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              border: index == entries.length - 1
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFEDF0F3)),
                    ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7785),
                    ),
                  ),
                ),
                Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
