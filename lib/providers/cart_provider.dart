import 'package:flutter/material.dart';
import '../models/perfume_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    int total = 0;
    _items.forEach((key, item) {
      total += item.quantity;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.perfume.price * item.quantity;
    });
    return total;
  }

  double get deliveryCost => items.isEmpty ? 0.00 : 20.00;

  double get finalTotalCost => totalAmount + deliveryCost;

  void addToBasket(PerfumeModel perfume) {
    if (_items.containsKey(perfume.id)) {
      _items.update(
        perfume.id,
            (existingItem) => CartItem(
          perfume: existingItem.perfume,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        perfume.id,
            () => CartItem(perfume: perfume, quantity: 1),
      );
    }
    notifyListeners();
  }

  void decrementQuantity(String perfumeId) {
    if (!_items.containsKey(perfumeId)) return;

    if (_items[perfumeId]!.quantity > 1) {
      _items.update(
        perfumeId,
            (existingItem) => CartItem(
          perfume: existingItem.perfume,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(perfumeId);
    }
    notifyListeners();
  }

  void removeItem(String perfumeId) {
    _items.remove(perfumeId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final PerfumeModel perfume;
  final int quantity;

  CartItem({required this.perfume, required this.quantity});
}