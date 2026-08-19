import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';

/// ÜRÜN LİSTESİ EKRANI
///
/// Ana sayfadan Route Arguments ile gelen [ProductService] ve seçili kategori
/// bilgisiyle çalışır. Arama ve kategori filtrelemesi bu ekranda yapılır.
class ProductListPage extends StatefulWidget {
  final ProductService service;
  final String initialCategory;

  const ProductListPage({
    super.key,
    required this.service,
    required this.initialCategory,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late String _category = widget.initialCategory;
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Product product) {
    Navigator.pushNamed(context, '/urun-detay', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.service.search(_keyword, category: _category);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          _buildCategoryFilter(),
          _buildResultCount(products.length),
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : _buildGrid(products),
          ),
        ],
      ),
    );
  }

  /// Basit arama alanı (Gün 4: arama ve filtreleme mantığı).
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _keyword = value),
        decoration: InputDecoration(
          hintText: 'Ürün ara…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _keyword.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _keyword = '');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Kategori seçim şeridi — ChoiceChip ile.
  Widget _buildCategoryFilter() {
    final categories = widget.service.categories;

    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category),
            selected: _category == category,
            onSelected: (_) => setState(() => _category = category),
          );
        },
      ),
    );
  }

  Widget _buildResultCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$count ürün listeleniyor',
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7785)),
        ),
      ),
    );
  }

  /// GridView.builder ile ürün kartları.
  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => _openDetail(product),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Color(0xFF9AA5B1)),
            SizedBox(height: 12),
            Text(
              'Aramanıza uygun ürün bulunamadı',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'Farklı bir kelime deneyin veya kategori filtresini değiştirin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7785)),
            ),
          ],
        ),
      ),
    );
  }
}
