import 'package:flutter/material.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175), // E-money theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deposit Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement deposit logic
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175), // E-money theme color
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Deposit',
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
}
