import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';

class GiftCodeTransaction extends Transaction { // Untuk mencatat history
  final String code;

  GiftCodeTransaction({
    required String recipient,
    required double amount,
    required DateTime date,
    required this.code,
  }) : super(
          type: recipient,
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
        title: Text(
          'Deposit',
          style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 30, color:Color.fromARGB(255, 51, 22, 138)),
        ),
        backgroundColor: Color.fromARGB(255, 134, 255, 154),
        iconTheme: IconThemeData(
            color: Color.fromARGB(255, 51, 22, 138)),
      ),
      backgroundColor: Color.fromARGB(255, 51, 22, 138),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Enter Gift Code',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
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
                      labelStyle: TextStyle(
                          fontFamily: 'PoppinsBold',
                          height: 3.5,
                          fontSize: 24,
                          color: Color.fromARGB(255, 51, 22, 138),),
                      filled: true,
                      fillColor: Color.fromARGB(255, 134, 255, 154),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 134, 255, 154),
                            width: 3.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(
                        fontFamily: 'PoppinsBold',
                        fontSize: 24,
                        color: Color.fromARGB(255, 51, 22, 138)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _redeemCode();
              },
              child: Text(
                'Redeem',
                style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 24,
                    color: Color.fromARGB(255, 51, 22, 138)),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 134, 255, 154),
              ),
            ),
            Divider(
                height: 100,
                thickness: 10,
                color: Color.fromARGB(255, 45, 19, 121)),
            Text(
              'Generated Code',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
            ),
            Text(
              '${isCodeVisible ? generatedCode : '*******'}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCodeVisible = !isCodeVisible;
                });
              },
              child: Text('Show/Hide Code',
                  style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 22,
                      color: Color.fromARGB(255, 51, 22, 138))),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 134, 255, 154),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Choose amount',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
            ),
            DropdownButton<int>(
              dropdownColor: Color.fromARGB(255, 44, 19, 119),
              value: selectedAmount,
              items: amounts.map((amount) {
                return DropdownMenuItem<int>(
                  value: amount,
                  child: Text(
                    'Rp $amount',
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        fontSize: 20,
                        color: Color.fromARGB(255, 134, 255, 154)),
                  ),
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
              child: Text('Pay',
                  style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 32,
                      color: Color.fromARGB(255, 51, 22, 138))),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 134, 255, 154),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateAndDisplayCode() { // Membuat dan menampilkan giftcode
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

  void _redeemCode() { // Fungsi menambahkan balance ketika giftcode benar
    String enteredCode = enteredCodeController.text;

    if (isCodeVisible && enteredCode == generatedCode) {
      Money.redeemGiftCode(enteredCode, selectedAmount.toDouble());

      Money.transactionHistory.add(
        GiftCodeTransaction(
          recipient: 'GiftCode',
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

  String _generateRandomCode() { // buat kode random
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }
}
