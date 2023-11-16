import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uas_emoney/money.dart';

class giftcodePage extends StatefulWidget {
  const giftcodePage({Key? key}) : super(key: key);

  @override
  _giftcodePageState createState() => _giftcodePageState();
}

class _giftcodePageState extends State<giftcodePage> {
  final List<String> giftCodes = [];
  final List<int> amounts = [20000, 50000, 100000, 250000];
  int selectedAmount = 20000; // Default amount
  late String generatedCode = ''; // Initialize with an empty string
  TextEditingController enteredCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Gift Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Amount:'),
            DropdownButton<int>(
              value: selectedAmount,
              items: amounts.map((amount) {
                return DropdownMenuItem<int>(
                  value: amount,
                  child: Text('Rp $amount'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAmount = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAndDisplayCode,
              child: Text('Pay'),
            ),
            SizedBox(height: 20), // Add spacing
            Text('Generated Code: $generatedCode'), // Display the generated code
            SizedBox(height: 20), // Add spacing
            TextField(
              controller: enteredCodeController,
              onChanged: (value) {
                // You can add additional logic here if needed
              },
              decoration: InputDecoration(
                labelText: 'Enter Gift Code',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _redeemCode();
              },
              child: Text('Redeem'),
            ),
          ],
        ),
      ),
    );
  }

  void _generateAndDisplayCode() {
    // Generate a random string code
    generatedCode = _generateRandomCode();

    // Save the generated code
    giftCodes.add(generatedCode);

    // Display the generated code in the UI
    setState(() {});
  }

  void _redeemCode() {
    String enteredCode = enteredCodeController.text;

    if (enteredCode == generatedCode) {
      // Entered code matches the generated code, redeem the gift
      Money.redeemGiftCode(enteredCode, selectedAmount.toDouble());
      Navigator.pop(context); // Close the gift code page
    } else {
      // Show an error message or take appropriate action
      print('Invalid gift code');
    }
  }

  String _generateRandomCode() {
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String code = '';

    for (int i = 0; i < 9; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }
}