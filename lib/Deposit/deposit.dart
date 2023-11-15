import 'package:flutter/material.dart';
import 'package:uas_emoney/Deposit/debit.dart';
import 'package:uas_emoney/Deposit/atm.dart';
import 'package:uas_emoney/Deposit/mobileBanking.dart';
import 'package:uas_emoney/Deposit/giftcode.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildDepositButton(context, Icons.add_card, 'Debit Visa/Mastercard', debitPage()),
            buildDepositButton(context, Icons.money, 'ATM', atmPage()),
            buildDepositButton(context, Icons.phone_android, 'Internet/Mobile Banking', mobileBankingPage()),
            buildDepositButton(context, Icons.card_giftcard, 'Giftcode', giftcodePage()),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget buildDepositButton(BuildContext context, IconData icon, String label, Widget page) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            navigateToPage(context, page);
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 147, 76, 175), // Set button color to E-money theme color
            padding: EdgeInsets.symmetric(vertical: 10), // Adjust the vertical padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Icon(
                icon,
                color: Colors.white, // Set icon color to white
                size: 40,
              ),
              SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
