import 'package:flutter/material.dart';

import '../services/cart_service.dart';

/// AppBar'da yer alan, sepetteki ürün adedini rozet olarak gösteren buton.
///
/// `ValueListenableBuilder` sayesinde sepet her değiştiğinde yalnızca bu
/// bölüm yeniden çizilir (basit state güncelleme örneği).
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: cart.lines,
      builder: (context, lines, child) {
        final count = cart.itemCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              tooltip: 'Sepet',
              onPressed: () => Navigator.pushNamed(context, '/sepet'),
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0803C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
