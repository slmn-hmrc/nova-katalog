import 'package:flutter/material.dart';

import 'models/product.dart';
import 'pages/cart_page.dart';
import 'pages/home_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/product_list_page.dart';
import 'services/product_service.dart';

void main() {
  runApp(const NovaKatalogApp());
}

/// NovaStore Mini Katalog uygulamasının kök widget'ı.
///
/// Yönerge gereği yalnızca `material.dart` kullanılmıştır; ek paket yoktur.
/// Sayfa geçişleri Named Routes ile, veri aktarımı Route Arguments ile yapılır.
class NovaKatalogApp extends StatelessWidget {
  const NovaKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaStore Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/sepet': (context) => const CartPage(),
      },
      // Argüman taşıyan rotalar onGenerateRoute üzerinden oluşturulur.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/urunler':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ProductListPage(
                service: args['service'] as ProductService,
                initialCategory: args['category'] as String,
              ),
              settings: settings,
            );

          case '/urun-detay':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
              settings: settings,
            );

          default:
            return null;
        }
      },
    );
  }

  /// Uygulamanın basit tema yapılandırması (Gün 5: basit UI teması oluşturma).
  ThemeData _buildTheme() {
    const primary = Color(0xFF2F4257);
    const accent = Color(0xFFF0803C);
    const surface = Color(0xFFF4F6F8);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primary,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2F4257),
        ),
        secondaryLabelStyle:
            const TextStyle(fontSize: 13, color: Colors.white),
        side: const BorderSide(color: Color(0xFFDDE3EA)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
