import 'package:chocs_to_go_shop/core/constants.dart';
import 'package:chocs_to_go_shop/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ChocsToGoShop()));
}

class ChocsToGoShop extends StatelessWidget {
  const ChocsToGoShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(dividerColor: customButtonTextColor),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}
