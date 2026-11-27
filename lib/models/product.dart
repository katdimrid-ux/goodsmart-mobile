class Product {
  final String id;
  final Map<String, String> names;
  final String categoryKey;
  final String store;
  final double price;
  final String unit;
  final String imageUrl;

  const Product({
    required this.id,
    required this.names,
    required this.categoryKey,
    required this.store,
    required this.price,
    required this.unit,
    required this.imageUrl,
  });

  String getName(String lang) => names[lang] ?? names['FR']!;
}

const List<String> availableStores = [
  'Tout',
  'Super Save',
  'Melcom Plus',
  'Palace Mall',
  'Shoprite Accra',
];

const List<Product> dummyProducts = [
  Product(
    id: '1',
    names: {
      'FR': 'Tomates fraîches',
      'EN': 'Fresh Tomatoes',
      'ZH': '新鲜番茄',
      'JA': '新鮮なトマト',
    },
    categoryKey: 'vegetables',
    store: 'Super Save',
    price: 15.0,
    unit: '1 kg',
    imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
  ),
  Product(
    id: '2',
    names: {
      'FR': 'Oignons rouges',
      'EN': 'Red Onions',
      'ZH': '红洋葱',
      'JA': '赤玉ねぎ',
    },
    categoryKey: 'vegetables',
    store: 'Melcom Plus',
    price: 12.0,
    unit: '1 kg',
    imageUrl: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400',
  ),
  Product(
    id: '3',
    names: {
      'FR': 'Riz Parfumé Jasmin',
      'EN': 'Jasmine Fragrant Rice',
      'ZH': '茉莉香米',
      'JA': 'ジャスミンライス',
    },
    categoryKey: 'grains',
    store: 'Palace Mall',
    price: 85.0,
    unit: '5 kg',
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
  ),
  Product(
    id: '4',
    names: {
      'FR': 'Huile végétale',
      'EN': 'Vegetable Oil',
      'ZH': '植物油',
      'JA': '植物油',
    },
    categoryKey: 'grocery',
    store: 'Super Save',
    price: 45.0,
    unit: '1 L',
    imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
  ),
  Product(
    id: '5',
    names: {
      'FR': 'Bananes Plantains',
      'EN': 'Plantain Bananas',
      'ZH': '大蕉',
      'JA': 'プランテンバナナ',
    },
    categoryKey: 'fruits',
    store: 'Shoprite Accra',
    price: 20.0,
    unit: '4 pcs',
    imageUrl: 'https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=400',
  ),
  Product(
    id: '6',
    names: {
      'FR': 'Piment frais (Kpakpo)',
      'EN': 'Fresh Chili Pepper',
      'ZH': '新鲜辣椒',
      'JA': 'フレッシュチリ',
    },
    categoryKey: 'spices',
    store: 'Super Save',
    price: 8.0,
    unit: '250 g',
    imageUrl: 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=400',
  ),
];