import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  String selectedAmount = ''; // Default amount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175), // Warna tema e-money
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter custom amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedAmount = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Jumlah Tunai',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                _buildNominalRadioButton('Rp. 50,000', '50000'),
                _buildNominalRadioButton('Rp. 100,000', '100000'),
                _buildNominalRadioButton('Rp. 200,000', '200000'),
                _buildNominalRadioButton('Rp. 300,000', '300000'),
                _buildNominalRadioButton('Rp. 500,000', '500000'),
                _buildNominalRadioButton('Rp. 1,000,000', '1000000'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement withdrawal logic
                print('Withdraw amount: $selectedAmount');
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175), // Warna tema e-money
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Withdraw',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNominalRadioButton(String label, String amount) {
    return Row(
      children: [
        Radio(
          value: amount,
          groupValue: selectedAmount,
          onChanged: (String? value) {
            setState(() {
              selectedAmount = value!;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
