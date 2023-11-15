import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
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
                'Penerima',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: recipientController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama penerima atau ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _onTransferButtonPressed(context);
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

  void _onTransferButtonPressed(BuildContext context) {
    String recipient = recipientController.text;
    String amount = amountController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferSuccessPage(recipient, amount),
      ),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Selamat, Anda telah berhasil mentransfer:',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Penerima: $recipient',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Jumlah: Rp $amount',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
TextEditingController recipientController = TextEditingController();
TextEditingController amountController = TextEditingController();
