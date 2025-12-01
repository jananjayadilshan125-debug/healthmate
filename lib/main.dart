import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/login_screen.dart';
import 'features/health_records/providers/record_provider.dart';
import 'features/health_records/screens/dashboard_screen.dart';
import 'features/health_records/screens/list_screen.dart';
import 'features/health_records/screens/add_record_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecordProvider()..loadRecords(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      routes: {
        "/login": (_) => LoginScreen(),
        "/dashboard": (_) => DashboardScreen(),
        "/list": (_) => RecordListScreen(),
        "/add": (_) => AddRecordScreen(),
      },
    );
  }
}
