import 'package:chocs_to_go_shop/data_classes/bag_product.dart';
import 'package:chocs_to_go_shop/data_classes/chocolates_data.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BagProvider extends StateNotifier<List<BagProduct>> {
  BagProvider() : super([]);

  addToBag(Chocolates _chocolate) {
    if (_chocolate.quantity == 0) {
      return Future.error('No stock left');
    }

    Iterable<BagProduct> _duplicates = _checkForDuplicates(_chocolate);

    if (_duplicates.isNotEmpty) {
      return increaseProductQuantity(_duplicates.first);
    } else {
      state.add(BagProduct(bagQuantity: 1, chocolate: _chocolate));
      state = state.toList();
    }
  }

  Iterable<BagProduct> _checkForDuplicates(Chocolates _chocolate) {
    Iterable<BagProduct> duplicates = state.where((element) {
      return element.chocolate.productID == _chocolate.productID;
    });

    return duplicates;
  }

  increaseProductQuantity(BagProduct productToBag) {
    if (productToBag.bagQuantity >= productToBag.chocolate.quantity) {
      EasyLoading.showError('No stock left');
      return Future.error('No stock left');
    }

    for (var element in state) {
      if (element.chocolate.productID == productToBag.chocolate.productID) {
        element.bagQuantity++;
      }
    }

    state = state.toList();
  }

  decreaseProductQuantity(BagProduct productToBag) {
    for (var bagProduct in state) {
      if (bagProduct.chocolate.productID == productToBag.chocolate.productID) {
        if (bagProduct.bagQuantity == 1) {
          removeProductFromBag(bagProduct);
          return;
        }

        bagProduct.bagQuantity--;
      }
    }

    state = state.toList();
  }

  removeProductFromBag(BagProduct bagProduct) {
    state.remove(bagProduct);

    state = state.toList();
  }

  clearBag() {
    state = [];
  }
}
