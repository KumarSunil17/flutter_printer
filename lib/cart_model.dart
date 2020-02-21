import 'dart:collection';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<Cart> _items = [];

  UnmodifiableListView<Cart> get items => UnmodifiableListView(_items);

  double get totalPrice {
    double price = 0;
    _items.forEach((element) {
      price += element.price;
    });
    return price;
  }

  void add(Cart item) {
    
    _items.add(item);
    notifyListeners();
  }

  void remove(Cart item) {
    _items.remove(item);
    notifyListeners();
  }
}

class Cart {
  String name;
  double price;
  Cart({this.name, this.price});

  @override
  String toString() {
    return 'Name $name Price $price';
  }

  @override
  bool operator ==(Object obj) {
    return obj is Cart && obj.name == this.name && obj.price == price;
  }

  @override
  int get hashCode => super.hashCode;
}
