import 'package:flutter/material.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const WorldExplorerApp());
}

class WorldExplorerApp extends StatelessWidget {
  const WorldExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Explorer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}