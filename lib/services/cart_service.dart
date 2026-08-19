import 'package:flutter/material.dart';

import '../models/product.dart';

/// Sepetteki tek bir satır (ürün + adet).
class CartLine {
  final Product product;
  int quantity;

  CartLine({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

/// Basit sepet simülasyonu (Gün 5 konusu: sepet butonu ile state güncelleme).
///
/// Ek paket kullanılmadığı için Flutter'ın kendi [ValueNotifier] yapısı tercih
/// edilmiştir. Değişiklikler `ValueListenableBuilder` ile dinlenir.
class CartService {
  CartService._();

  /// Uygulama genelinde tek bir sepet örneği kullanılır.
  static final CartService instance = CartService._();

  final ValueNotifier<List<CartLine>> lines = ValueNotifier<List<CartLine>>([]);

  /// Sepetteki toplam ürün adedi (rozet üzerinde gösterilir).
  int get itemCount =>
      lines.value.fold<int>(0, (sum, line) => sum + line.quantity);

  /// Sepet tutarı.
  double get total => lines.value.fold<double>(0, (sum, line) => sum + line.total);

  /// Ürünü sepete ekler; ürün zaten varsa adedini artırır.
  void add(Product product) {
    final current = [...lines.value];
    final index = current.indexWhere((line) => line.product.id == product.id);

    if (index == -1) {
      current.add(CartLine(product: product));
    } else {
      current[index].quantity += 1;
    }

    lines.value = current;
  }

  /// Adedi bir azaltır; sıfıra inerse satırı kaldırır.
  void decrease(Product product) {
    final current = [...lines.value];
    final index = current.indexWhere((line) => line.product.id == product.id);
    if (index == -1) return;

    if (current[index].quantity <= 1) {
      current.removeAt(index);
    } else {
      current[index].quantity -= 1;
    }

    lines.value = current;
  }

  /// Satırı tamamen kaldırır.
  void remove(Product product) {
    lines.value =
        lines.value.where((line) => line.product.id != product.id).toList();
  }

  /// Sepeti boşaltır.
  void clear() => lines.value = [];
}
