import 'package:chocs_to_go_shop/data_classes/chocolates_data.dart';

class BagProduct {
  int bagQuantity;
  final Chocolates chocolate;
  BagProduct({
    required this.bagQuantity,
    required this.chocolate,
  });

  BagProduct.empty()
      : chocolate = Chocolates.empty(),
        bagQuantity = 0;

  @override
  String toString() => 'BagProduct(BagQuantity: $bagQuantity, chocolate: $chocolate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BagProduct &&
      other.bagQuantity == bagQuantity &&
      other.chocolate == chocolate;
  }

  @override
  int get hashCode => bagQuantity.hashCode ^ chocolate.hashCode;

  BagProduct copyWith({
    int? bagQuantity,
    Chocolates? chocolate,
  }) {
    return BagProduct(
      bagQuantity: bagQuantity ?? this.bagQuantity,
      chocolate: chocolate ?? this.chocolate,
    );
  }
}
