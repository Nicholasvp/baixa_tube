import 'package:baixa_tube/core/routes/routes.dart';
import 'package:elevarm_ui/elevarm_ui.dart';
import 'package:flutter/material.dart';

void main() {
  ElevarmFontFamilies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ElevarmThemeData.light(),
      routerConfig: router,
    );
  }
}
