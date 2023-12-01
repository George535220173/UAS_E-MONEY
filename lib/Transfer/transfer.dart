import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';
import 'package:uas_emoney/pin.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer',
          style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 26),
        ),
        backgroundColor: Color.fromARGB(255, 149, 10, 98),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Wizzzzz test bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 230, 15, 122),
                child: Icon(
                  Icons.account_circle,
                  size: 95,
                  color: Color.fromARGB(255, 94, 3, 48),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nomor Penerima',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 230, 15, 122),
                ),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(150, 94, 3, 48),
                  border: Border.all(
                      color: Color.fromARGB(255, 230, 15, 122), width: 3.5),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '(+62)',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsBold',
                            color: Color.fromARGB(255, 230, 15, 122)),
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
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'PoppinsRegular',
                              color: Color.fromARGB(255, 230, 15, 122)),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                        ),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsBold',
                            color: Color.fromARGB(255, 230, 15, 122)),
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
                  fontSize: 28,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 230, 15, 122),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsFormatter(),
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 230, 15, 122),
                  hintText: 'Masukkan Jumlah',
                  hintStyle: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'PoppinsRegular',
                      color: Color.fromARGB(255, 94, 3, 48)),
                  border: OutlineInputBorder(),
                  errorText: _validateAmount(amountController.text),
                ),
                style: TextStyle(
                    fontSize: 21.0,
                    fontFamily: 'PoppinsBold',
                    color: Color.fromARGB(255, 94, 3, 48)),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  String amount = amountController.text;
                  final double transferAmount =
                      double.tryParse(amount.replaceAll('.', '')) ?? 0.0;
                  if (transferAmount >= 10000) {
                    _showPasswordDialog(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content:
                              Text('Minimum transfer amount is Rp 10,000.'),
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
                  primary: Color.fromARGB(255, 230, 15, 122),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        color: Color.fromARGB(255, 94, 3, 48),
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Transfer',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'PoppinsBold',
                            color: Color.fromARGB(255, 94, 3, 48)),
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
    String amount = amountController.text.replaceAll('.', ''); // Hilangkan koma
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
                      'Rp. ${NumberFormat('#,###', 'id_ID').format(transferAmount)} has been transferred to another account.'),
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
    // Hilangkan koma dari nilai yang dimasukkan
    final double transferAmount =
        double.tryParse(value.replaceAll('.', '')) ?? 0.0;

    // Periksa apakah nilai setelah diformat kurang dari 10000
    if (transferAmount < 10000) {
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

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final String newText = newValue.text.replaceAll(',', '');
    final double value = double.parse(newText);

    final String formattedValue =
        NumberFormat('#,###', 'id_ID').format(value).replaceAll('IDR', '');

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

TextEditingController recipientController = TextEditingController();
TextEditingController amountController = TextEditingController();
