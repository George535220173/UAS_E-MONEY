import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';
import 'package:uas_emoney/pin.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color.fromARGB(255, 147, 76, 175),
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nomor Penerima',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              // TextField Nomor Penerima
              Container(
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '(+62)',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: recipientController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor Penerima',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Jumlah',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Masukkan Jumlah',
                  border: OutlineInputBorder(),
                  errorText: _validateAmount(amountController.text),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Get the entered amount from the controller
                  String amount = amountController.text;
                  double transferAmount = double.tryParse(amount) ?? 0.0;

                  // Check if the transfer amount is greater than or equal to 10,000
                  if (transferAmount >= 10000) {
                    _showPasswordDialog(context);
                  } else {
                    // Show an error message if the amount is less than 10,000
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Minimum transfer amount is Rp 10,000.'),
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
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 147, 76, 175),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 10),
                      Text(
                        'Transfer',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    String amount = amountController.text;
    String recipient = recipientController.text;
    double transferAmount = double.tryParse(amount) ?? 0.0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinCodeWidget(
          onPinVerified: () {
            Navigator.pop(context);
            Money.transferToPhoneNumber(recipient, transferAmount);
            Money.transactionHistory.add(Transaction(
                type: recipient, amount: transferAmount, date: DateTime.now()));
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text(
                      'Rp. $amount has been transferred to another account.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          onPinFailed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Incorrect PIN'),
                  content: Text('The entered PIN is incorrect.'),
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
          },
        ),
      ),
    );
  }

  String? _validateAmount(String value) {
    double enteredAmount = double.tryParse(value) ?? 0.0;

    if (enteredAmount < 10000) {
      return 'Minimum transfer amount is Rp 10,000.';
    }

    return null;
  }
}

class TransferSuccessPage extends StatelessWidget {
  final String recipient;
  final String amount;

  TransferSuccessPage(this.recipient, this.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Berhasil'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'Transfer Berhasil!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Selamat, Anda telah berhasil mentransfer kepada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'ID: $recipient',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Jumlah: Rp $amount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextEditingController recipientController = TextEditingController();
TextEditingController amountController = TextEditingController();