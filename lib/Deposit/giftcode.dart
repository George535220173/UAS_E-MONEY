import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';

class GiftCodeTransaction extends Transaction {
  final String code;

  GiftCodeTransaction({
    required String recipient,
    required double amount,
    required DateTime date,
    required this.code,
  }) : super(
          recipient: recipient,
          amount: amount,
          date: date,
        );
}

class giftcodePage extends StatefulWidget {
  const giftcodePage({Key? key}) : super(key: key);

  @override
  _giftcodePageState createState() => _giftcodePageState();
}

class _giftcodePageState extends State<giftcodePage> {
  final List<String> giftCodes = [];
  final List<int> amounts = [20000, 50000, 100000, 250000];
  int selectedAmount = 20000;
  late String generatedCode = '';
  TextEditingController enteredCodeController = TextEditingController();
  bool isCodeVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Gift Code'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Enter Gift Code:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Container(
                  width: 200,
                  child: TextField(
                    controller: enteredCodeController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _redeemCode();
              },
              child: Text('Redeem'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175),
              ),
            ),
            Divider(
                height: 100,
                thickness: 10,
                color: Color.fromARGB(255, 147, 76, 175)),
            Text(
              'Generated Code:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${isCodeVisible ? generatedCode : '*******'}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCodeVisible = !isCodeVisible;
                });
              },
              child: Text('Show/Hide Code'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175),
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Choose amount',
              style: TextStyle(fontSize: 24),
            ),
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _generateAndDisplayCode();
              },
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateAndDisplayCode() {
    generatedCode = _generateRandomCode();

    giftCodes.add(generatedCode);

    setState(() {});

    int paymentAmount = selectedAmount + Random().nextInt(100) + 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment'),
          content:
              Text('Transfer credit of Rp.$paymentAmount to 0812 3456 7890'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done!'),
            ),
          ],
        );
      },
    );
  }

  void _redeemCode() {
    String enteredCode = enteredCodeController.text;

    if (isCodeVisible && enteredCode == generatedCode) {
      Money.redeemGiftCode(enteredCode, selectedAmount.toDouble());

      Money.transactionHistory.add(
        GiftCodeTransaction(
          recipient: 'GiftCode', // Provide the recipient value as needed
          amount: selectedAmount.toDouble(),
          date: DateTime.now(),
          code: enteredCode,
        ),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Code Redeemed'),
            content: Text('Balance has been updated.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Gift Code'),
            content: Text(
                'The entered gift code is invalid. Please check and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String _generateRandomCode() {
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }
}
