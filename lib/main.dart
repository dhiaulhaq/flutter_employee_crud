import 'package:flutter/material.dart';
import 'widgets/DataTableEmployee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee CRUD',
      home: new DataTableEmployee(),
    );
  }
}
