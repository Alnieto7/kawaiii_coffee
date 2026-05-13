// lib/Component/Cart/cart_format_helper.dart

String formatRupiah(int value) {
  final str = value.toString();
  final result = StringBuffer();
  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) result.write('.');
    result.write(str[i]);
    count++;
  }
  return result.toString().split('').reversed.join('');
}
