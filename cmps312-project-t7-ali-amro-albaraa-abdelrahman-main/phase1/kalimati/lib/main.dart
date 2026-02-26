import 'package:class_manager/core/data/database/database_service.dart';
import 'package:class_manager/core/navigations/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.getDatabase();

  runApp(const ProviderScope(child: Kalimati()));
}

class Kalimati extends StatelessWidget {
  const Kalimati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: AppRoute.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
