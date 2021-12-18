import 'package:flutter/material.dart';
import 'package:maafos/Providers/CartProvider.dart';
import 'package:maafos/Providers/GetDataProvider.dart';
import 'package:maafos/Providers/GroceryProvider.dart';
import 'package:maafos/Providers/PopularProvider.dart';
import 'package:maafos/Providers/StoreProvider.dart';
import 'package:maafos/Screens/AuthFiles/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<GetDataProvider>(create: (_) => GetDataProvider()),
  ChangeNotifierProvider<StoreProvider>(create: (_) => StoreProvider()),
  ChangeNotifierProvider<PopularProvider>(create: (_) => PopularProvider()),
  ChangeNotifierProvider<GroceryProvider>(create: (_) => GroceryProvider()),
  ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Proxima Nova',
            colorScheme: ThemeData().colorScheme.copyWith(
                  secondary: Colors.blue,
                ),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
