import 'package:chocs_to_go_shop/core/constants.dart';
import 'package:chocs_to_go_shop/core/providers_definition.dart';
import 'package:chocs_to_go_shop/data_classes/bag_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BagTile extends ConsumerWidget {
  const BagTile({Key? key, required this.product}) : super(key: key);

  final BagProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          //  top: BorderSide(color: customButtonTextColor, width: 0.5),
          bottom: BorderSide(color: customButtonTextColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // SizedBox(
          //   height: 80,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Image.asset(
          //       'assets/${product.chocolate.productID}.jpg',
          //       fit: BoxFit.scaleDown,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.chocolate.productName,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(product.chocolate.flavor),
                Text(product.chocolate.netWeightString),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  product.chocolate.priceStringPHP,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: customButtonShape,
                          primary: customAccentColor,
                        ),
                        onPressed: () {
                          ref.read(bagProvider.notifier).decreaseProductQuantity(product);
                        },
                        child: Text(
                          '-',
                          style: TextStyle(color: customButtonTextColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(product.bagQuantity.toString()),
                    SizedBox(
                      width: 30,
                      height: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: customButtonShape,
                          primary: customAccentColor,
                        ),
                        onPressed: () {
                          ref.read(bagProvider.notifier).increaseProductQuantity(product);
                        },
                        child: Text(
                          '+',
                          style: TextStyle(color: customButtonTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
