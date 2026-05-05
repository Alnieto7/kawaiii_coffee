// import 'package:flutter/foundation.dart';
// import 'package:kawaiii_coffee/Model/menuitem.dart';


// class PosController extends ChangeNotifier {
//   // ── State ──────────────────────────────────────────────
//   String _selectedCategory = 'Semua';
//   String _searchQuery = '';
//   final List<CartItem> _cartItems = [];
//   int _currentNavIndex = 1; // POS is default

//   // ── Data ───────────────────────────────────────────────
//   final List<String> categories = [
//     'Semua',
//     'Espresso Base',
//     'Manual Brew',
//     'Non Coffee',
//   ];

//   final List<MenuItem> _allMenuItems = const [
//     MenuItem(
//       id: '1',
//       name: 'Espresso Double',
//       price: 18000,
//       imageUrl: 'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400',
//       category: 'Espresso Base',
//     ),
//     MenuItem(
//       id: '2',
//       name: 'Caffè Latte',
//       price: 25000,
//       imageUrl: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400',
//       category: 'Espresso Base',
//     ),
//     MenuItem(
//       id: '3',
//       name: 'Cold Brew Signature',
//       price: 28000,
//       imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
//       category: 'Manual Brew',
//     ),
//     MenuItem(
//       id: '4',
//       name: 'Cappuccino',
//       price: 24000,
//       imageUrl: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400',
//       category: 'Espresso Base',
//     ),
//     MenuItem(
//       id: '5',
//       name: 'V60 Pour Over',
//       price: 32000,
//       imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
//       category: 'Manual Brew',
//     ),
//     MenuItem(
//       id: '6',
//       name: 'Matcha Latte',
//       price: 28000,
//       imageUrl: 'https://images.unsplash.com/photo-1515823662972-da6a2e4d3002?w=400',
//       category: 'Non Coffee',
//     ),
//     MenuItem(
//       id: '7',
//       name: 'Americano',
//       price: 20000,
//       imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
//       category: 'Espresso Base',
//     ),
//     MenuItem(
//       id: '8',
//       name: 'Flat White',
//       price: 26000,
//       imageUrl: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=400',
//       category: 'Espresso Base',
//     ),
//   ];

//   // ── Getters ────────────────────────────────────────────
//   String get selectedCategory => _selectedCategory;
//   String get searchQuery => _searchQuery;
//   List<CartItem> get cartItems => List.unmodifiable(_cartItems);
//   int get currentNavIndex => _currentNavIndex;

//   List<MenuItem> get filteredMenuItems {
//     return _allMenuItems.where((item) {
//       final matchesCategory =
//           _selectedCategory == 'Semua' || item.category == _selectedCategory;
//       final matchesSearch =
//           item.name.toLowerCase().contains(_searchQuery.toLowerCase());
//       return matchesCategory && matchesSearch;
//     }).toList();
//   }

//   int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

//   int get cartTotal =>
//       _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

//   String get formattedCartTotal {
//     final formatted = cartTotal.toString().replaceAllMapped(
//       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//       (Match m) => '${m[1]}.',
//     );
//     return 'Rp $formatted';
//   }

//   bool isInCart(String menuItemId) =>
//       _cartItems.any((item) => item.menuItem.id == menuItemId);

//   int getItemQuantity(String menuItemId) {
//     final index = _cartItems.indexWhere((item) => item.menuItem.id == menuItemId);
//     return index != -1 ? _cartItems[index].quantity : 0;
//   }

//   // ── Actions ────────────────────────────────────────────
//   void selectCategory(String category) {
//     _selectedCategory = category;
//     notifyListeners();
//   }

//   void updateSearch(String query) {
//     _searchQuery = query;
//     notifyListeners();
//   }

//   void addToCart(MenuItem menuItem) {
//     final index = _cartItems.indexWhere((item) => item.menuItem.id == menuItem.id);
//     if (index != -1) {
//       _cartItems[index].quantity++;
//     } else {
//       _cartItems.add(CartItem(menuItem: menuItem));
//     }
//     notifyListeners();
//   }

//   void removeFromCart(String menuItemId) {
//     final index = _cartItems.indexWhere((item) => item.menuItem.id == menuItemId);
//     if (index != -1) {
//       if (_cartItems[index].quantity > 1) {
//         _cartItems[index].quantity--;
//       } else {
//         _cartItems.removeAt(index);
//       }
//       notifyListeners();
//     }
//   }

//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }

//   void setNavIndex(int index) {
//     _currentNavIndex = index;
//     notifyListeners();
//   }

//   void checkout() {
//     // Implement checkout logic here
//     clearCart();
//   }
// }