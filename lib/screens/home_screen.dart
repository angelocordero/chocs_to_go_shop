import 'package:chocs_to_go_shop/core/constants.dart';
import 'package:chocs_to_go_shop/core/providers_definition.dart';
import 'package:chocs_to_go_shop/core/utilites.dart';
import 'package:chocs_to_go_shop/data_classes/bag_product.dart';
import 'package:chocs_to_go_shop/data_classes/chocolates_data.dart';
import 'package:chocs_to_go_shop/screens/login_screen.dart';
import 'package:chocs_to_go_shop/widgets/bag_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String _flavor = 'Dark';
  static final ScrollController _gridViewController = ScrollController();
  static final TextEditingController _searchController = TextEditingController();
  static final ScrollController _bagListController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/home_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.8),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
                color: customButtonTextColor,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: customButtonTextColor),
              ),
            ),
          ],
          backgroundColor: customAccentColor,
          title: Text(
            'Chocs To Go Shop',
            style: TextStyle(color: customButtonTextColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: [
              _productView(context, ref),
              const SizedBox(
                width: 64,
              ),
              _bagView(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _bagView(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: customBGColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: customButtonTextColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/bag.png'),
                  Text(
                    'Bag (${ref.watch(totalProductQuantityProvider)})',
                    style: GoogleFonts.exo2(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: customButtonTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            _bagList(context, ref),
            _purchaseDetails(ref),
          ],
        ),
      ),
    );
  }

  Expanded _bagList(BuildContext context, WidgetRef ref) {
    List<BagProduct> _list = ref.watch(bagProvider);

    return Expanded(
      flex: 2,
      child: Visibility(
        visible: _list.isNotEmpty,
        replacement: const Center(
          child: Text('Empty bag'),
        ),
        child: ListView.builder(
          controller: _bagListController,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return BagTile(product: _list[index]);
          },
        ),
      ),
    );
  }

  Expanded _purchaseDetails(WidgetRef ref) {
    double _total = ref.watch(totalPriceProvider);

    return Expanded(
      flex: 1,
      child: Column(
        children: [
          const Divider(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Text(
                Utils.formatToPHPString(_total * 0.88),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Value Added Tax (12%)',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Text(
                Utils.formatToPHPString(_total * 0.12),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 24),
              ),
              const Spacer(),
              Text(
                Utils.formatToPHPString(_total),
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 5,
          ),
          const Divider(
            height: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: customButtonShape,
                  primary: customAccentColor,
                ),
                onPressed: () async {
                  ref.read(bagProvider.notifier).clearBag();
                },
                child: Text(
                  'Clear bag',
                  style: TextStyle(color: customButtonTextColor),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: customButtonShape,
                  primary: customAccentColor,
                ),
                onPressed: () {},
                child: Text(
                  'Order',
                  style: TextStyle(color: customButtonTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _productGrid(BuildContext context, WidgetRef ref) {
    List<Chocolates> _productList = ref.watch(chocolatesProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: GridView.builder(
        padding: const EdgeInsets.all(32),
        controller: _gridViewController,
        itemCount: _productList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          mainAxisExtent: 230,
        ),
        itemBuilder: (context, index) {
          Chocolates _product = _productList[index];

          return Container(
            decoration: BoxDecoration(
              color: customBGColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: customButtonTextColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/${_product.productID}.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _product.productName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _product.flavor,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        _product.netWeightString,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('In Stock: ${_product.quantity}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _product.priceStringPHP,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: customButtonShape,
                          primary: customAccentColor,
                        ),
                        onPressed: () async {
                          try {
                            await ref.read(bagProvider.notifier).addToBag(_product);
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        },
                        child: Text(
                          'Add to bag',
                          style: TextStyle(color: customButtonTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded _productView(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _search(ref),
          const SizedBox(
            height: 32,
          ),
          Expanded(
            child: _productGrid(context, ref),
          ),
        ],
      ),
    );
  }

  Row _search(WidgetRef ref) {
    List<String> _flavorsList = [
      'All',
      ...ChocolateFlavorsEnum.values.map((value) {
        return value.name;
      })
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Search:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 200,
          child: TextField(
            onChanged: (String input) {
              if (input.isEmpty) {
                ref.read(chocolatesProvider.notifier).clearSearch(ref);
              }
            },
            controller: _searchController,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(8.0),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: customButtonShape,
            primary: customAccentColor,
          ),
          onPressed: () {
            ref.read(chocolatesProvider.notifier).searchForProductName(_searchController.text);
          },
          child: Text(
            'Search using product name',
            style: TextStyle(color: customButtonTextColor),
          ),
        ),
        const Spacer(),
        SizedBox(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              dropdownColor: customBGColor,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: EdgeInsets.all(4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
              isDense: true,
              value: _flavorsList.first,
              style: const TextStyle(
                fontSize: 12,
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _flavorsList.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                },
              ).toList(),
              onChanged: (String? newValue) {
                _flavor = newValue ?? _flavor;
              },
            ),
          ),
          width: 150,
          height: 30,
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: customButtonShape,
            primary: customAccentColor,
          ),
          onPressed: () {
            ref.read(chocolatesProvider.notifier).searchForProductFlavor(_flavor, ref);
            _searchController.clear();
          },
          child: Text(
            'Filter by flavor',
            style: TextStyle(color: customButtonTextColor),
          ),
        ),
      ],
    );
  }
}
