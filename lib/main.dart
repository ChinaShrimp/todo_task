import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/dao/dao.dart';
import 'data/database/moor_database.dart';
import 'ui/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    return Provider(
      create: (_) => TaskDao(db),
      child: MaterialApp(
        title: 'Material App',
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
  }
}