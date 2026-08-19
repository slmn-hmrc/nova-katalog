import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';

/// ANA SAYFA — banner, kategori şeridi ve öne çıkan ürünler.
///
/// Uygulama açılışında katalog verisi `ProductService` üzerinden okunur ve
/// diğer sayfalara Route Arguments ile taşınır.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _service = ProductService();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    await _service.load();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  /// Ürün listesi sayfasına geçiş — seçilen kategori argüman olarak taşınır.
  void _openList(String category) {
    Navigator.pushNamed(
      context,
      '/urunler',
      arguments: {'service': _service, 'category': category},
    );
  }

  /// Ürün detay sayfasına geçiş (Gün 3: Route Arguments).
  void _openDetail(Product product) {
    Navigator.pushNamed(context, '/urun-detay', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaStore'),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                _buildBanner(),
                _buildCategoryStrip(),
                _buildSectionHeader(
                  title: 'Öne çıkanlar',
                  actionLabel: 'Tümünü gör',
                  onAction: () => _openList('Tümü'),
                ),
                _buildFeaturedGrid(),
              ],
            ),
    );
  }

  /// Banner görseli — asset yönetimi örneği.
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  /// Yatay kaydırılan kategori şeridi (ListView.builder — yatay yön).
  Widget _buildCategoryStrip() {
    final categories = _service.categories;

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ActionChip(
            label: Text(category),
            onPressed: () => _openList(category),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }

  /// Öne çıkan ürünler — GridView ile kart tabanlı tasarım.
  Widget _buildFeaturedGrid() {
    final featured = _service.featured;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: featured.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = featured[index];
        return ProductCard(
          product: product,
          onTap: () => _openDetail(product),
        );
      },
    );
  }
}
