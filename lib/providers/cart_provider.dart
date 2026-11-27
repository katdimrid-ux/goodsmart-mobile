import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

typedef CartState = Map<String, CartItem>;

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => {};

  void addItem(Product product) {
    addItemWithQuantity(product, 1);
  }

  void addItemWithQuantity(Product product, int qty) {
    if (qty <= 0) return;
    if (state.containsKey(product.id)) {
      state = {
        ...state,
        product.id: state[product.id]!.copyWith(
          quantity: state[product.id]!.quantity + qty,
        ),
      };
    } else {
      state = {
        ...state,
        product.id: CartItem(product: product, quantity: qty),
      };
    }
  }

  void removeSingleItem(String productId) {
    if (!state.containsKey(productId)) return;

    if (state[productId]!.quantity > 1) {
      state = {
        ...state,
        productId: state[productId]!.copyWith(
          quantity: state[productId]!.quantity - 1,
        ),
      };
    } else {
      final updated = CartState.from(state);
      updated.remove(productId);
      state = updated;
    }
  }

  void clearCart() {
    state = {};
  }

  int get totalItems =>
      state.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => state.values
      .fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
}

final cartProvider =
    NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggleFavorite(String productId) {
    final updated = Set<String>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class LanguageNotifier extends Notifier<String> {
  @override
  String build() => 'FR';

  void setLanguage(String lang) => state = lang;
}

final languageProvider =
    NotifierProvider<LanguageNotifier, String>(LanguageNotifier.new);

class LocationNotifier extends Notifier<String> {
  @override
  String build() => 'Legon Campus, Accra';

  void setLocation(String newLocation) => state = newLocation;
}

final locationProvider =
    NotifierProvider<LocationNotifier, String>(LocationNotifier.new);

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void signIn() => state = true;
  void signOut() => state = false;
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);