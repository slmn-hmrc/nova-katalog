/// Ürün veri modeli.
///
/// Gün 4 konusu: JSON mantığı ve model sınıfı oluşturma.
/// `fromJson` ile JSON'dan nesneye, `toJson` ile nesneden JSON'a dönüşüm yapılır.
class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final double rating;
  final String image;
  final String description;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.rating,
    required this.image,
    required this.description,
    required this.specs,
  });

  /// JSON haritasından Product nesnesi üretir.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String,
      specs: Map<String, String>.from(json['specs'] as Map),
    );
  }

  /// Product nesnesini tekrar JSON haritasına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'rating': rating,
      'image': image,
      'description': description,
      'specs': specs,
    };
  }

  /// Stok durumunun kullanıcıya gösterilecek metni.
  String get stockLabel {
    if (stock == 0) return 'Tükendi';
    if (stock < 10) return 'Son $stock ürün';
    return 'Stokta var';
  }

  /// Stok azaldığında uyarı rengiyle gösterilmesi için.
  bool get isLowStock => stock > 0 && stock < 10;

  /// Fiyatın "2.499,90 TL" biçimindeki gösterimi.
  String get priceLabel {
    final parts = price.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final buffer = StringBuffer();

    // Binlik ayracı olarak nokta eklenir (1234567 -> 1.234.567)
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
      buffer.write(whole[i]);
    }

    return '${buffer.toString()},${parts[1]} TL';
  }
}
