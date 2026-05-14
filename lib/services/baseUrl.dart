class ApiConfig {
  static const String baseUrl = 'https://kawaiiicoffee.cloud';
  static const String apiUrl = '$baseUrl/api';

  // Auth
  static const String login = '$apiUrl/auth/login';
  static const String logout = '$apiUrl/auth/logout';

  // Products
  static const String products = '$apiUrl/products';

  // Categories
  static const String categories = '$apiUrl/categories';

  // Ingredients
  static const String ingredients = '$apiUrl/ingredients';

  // Transactions
  static const String transactions = '$apiUrl/transactions';
  static const String initiateSnap = '$apiUrl/transactions/initiate';
  static const String initiateQris = '$apiUrl/transactions/initiate-qris';
  static const String midtransCallback = '$apiUrl/midtrans/callback';

  // Stock Movements
  static const String stockMovements = '$apiUrl/stock-movements';
  static const String adjustStock = '$apiUrl/stock-movements/adjust';

  // Reports
  static const String salesSummary = '$apiUrl/reports/sales-summary';
  static const String todaySales = '$apiUrl/reports/today-sales';
  static const String bestSellers = '$apiUrl/reports/best-sellers';
  static const String lowStock = '$apiUrl/reports/low-stock';
  static const String salesChart = '$apiUrl/reports/sales-chart';

  // Notifications
  static const String notifications = '$apiUrl/notifications';
  static const String saveToken = '$apiUrl/notifications/save-token';
  static const String readAll = '$apiUrl/notifications/read-all';

  // Audit Log
  static const String auditLogs = '$apiUrl/audit-logs';
}
