import 'package:chocs_to_go_shop/core/bag_provider.dart';
import 'package:chocs_to_go_shop/core/chocolates_provider.dart';
import 'package:chocs_to_go_shop/data_classes/bag_product.dart';
import 'package:chocs_to_go_shop/data_classes/chocolates_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

final chocolatesProvider = StateNotifierProvider<ChocolatesProvider, List<Chocolates>>((ref) {
  return ChocolatesProvider();
});

final mysqlConnectionProvider = StateProvider<ConnectionSettings>((ref) {
  return ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'angelo',
    password: 'krystelle12',
    db: 'cpe_221',
  );
});

final bagProvider = StateNotifierProvider<BagProvider, List<BagProduct>>((ref) {
  return BagProvider();
});

final totalPriceProvider = StateProvider<double>(
  (ref) {
    List<BagProduct> _bagList = ref.watch(bagProvider);

    double _price = 0;

    for (var element in _bagList) {
      _price = _price + (element.bagQuantity * element.chocolate.price);
    }

    return _price;
  },
);
final totalProductQuantityProvider = StateProvider<int>((ref) {
  List<BagProduct> _checkoutList = ref.watch(bagProvider);

  int _quantity = 0;

  for (var element in _checkoutList) {
    _quantity = _quantity + element.bagQuantity;
  }

  return _quantity;
});
