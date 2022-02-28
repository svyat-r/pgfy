import 'package:flutter/material.dart';
import 'package:pgfy/pages/home_page.dart';
import 'package:pgfy/providers/app_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());


class App extends StatelessWidget {

  final AppProvider appProvider = AppProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
      ],
      child: MaterialApp(
        title: 'PGFY',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
