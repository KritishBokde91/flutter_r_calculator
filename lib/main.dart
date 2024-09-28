import 'package:calculator_app/calculatorscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: "Calculator App",
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }

}