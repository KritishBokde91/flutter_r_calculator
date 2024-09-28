import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '';
  double num1 = 0;
  double num2 = 0;
  String operator = '';
  double result = 0;
  String displayText2 = '';

  Future<void> _calculateResult() async {
    final url = Uri.parse(
        'http://10.0.2.2:3622/calculate?num1=$num1&num2=$num2&op=$operator');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          final resultValue = data['result'][0];
          if(resultValue is int) {
            result = resultValue.toDouble();
          } else if(resultValue is double) {
            result = resultValue;
          } else {
            displayText = 'Unexpected result type';
            return;
          }
          displayText = result.toString();
          displayText2 = result.toString();
        });
      } else {
        setState(() {
          displayText = 'Server Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        displayText = 'Error: $e';
      });
    }
  }
  void _onButtonPressed(String value) async {
    setState(() {
      if (value == 'C') {
        displayText = '';
        displayText2 = '';
        num1 = 0;
        num2 = 0;
        result = 0;
        operator = '';
      } else if (value == '=') {
        num2 = double.parse(displayText);
        _calculateResult();
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        num1 = double.parse(displayText);
        operator = value;
        displayText = '';
        displayText2 = '$num1  $operator  ';
      } else {
        displayText += value;
        displayText2 += value;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculator App'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.black12,
                child: Text(
                  displayText2,
                  style: const TextStyle(color: Colors.white, fontSize: 48),
                  textAlign: TextAlign.right,
                ),
              ),
              _buildButtonRow(['7', '8', '9', '/']),
              _buildButtonRow(['4', '5', '6', '*']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['C', '0', '=', '+']),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons.map((buttonText) {
        return Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: ElevatedButton(
            onPressed: () => _onButtonPressed(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.21, MediaQuery.of(context).size.height * 0.1)
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 24, color: Colors.black)),
          ),
        );
      }).toList(),
    );
  }
}
