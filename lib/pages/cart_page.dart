import 'package:flutter/material.dart';

import '../services/cart_service.dart';

/// SEPET EKRANI — sepet simülasyonu.
///
/// Sepet içeriği `ValueListenableBuilder` ile dinlenir; adet değiştikçe
/// yalnızca liste yeniden çizilir.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: ValueListenableBuilder<List<CartLine>>(
        valueListenable: cart.lines,
        builder: (context, lines, child) {
          if (lines.isEmpty) return _buildEmpty(context);

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lines.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _buildLine(context, cart, lines[index]),
                ),
              ),
              _buildSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLine(BuildContext context, CartService cart, CartLine line) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              line.product.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  line.product.priceLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7785),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 22),
                onPressed: () => cart.decrease(line.product),
              ),
              Text(
                '${line.quantity}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                onPressed: () => cart.add(line.product),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartService cart) {
    final total = cart.total;
    final parts = total.toStringAsFixed(2).split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < parts[0].length; i++) {
      if (i > 0 && (parts[0].length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[0][i]);
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDF0F3))),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Toplam tutar',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7785)),
                  ),
                ),
                Text(
                  '${buffer.toString()},${parts[1]} TL',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  cart.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Siparişiniz alındı (simülasyon)'),
                    ),
                  );
                },
                child: const Text(
                  'Siparişi tamamla',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                size: 56, color: Color(0xFF9AA5B1)),
            const SizedBox(height: 14),
            const Text(
              'Sepetiniz boş',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Katalogdan beğendiğiniz ürünleri sepete ekleyebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7785)),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Alışverişe dön'),
            ),
          ],
        ),
      ),
    );
  }
}
