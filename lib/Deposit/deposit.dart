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
        title: Text(
          'Deposit',
          style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 149, 10, 98),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              buildDepositButton(context, Icons.add_card,
                  'Debit Visa/Mastercard', debitPage()),
              SizedBox(height: 20),
              buildDepositButton(context, Icons.money, 'ATM', atmPage()),
              SizedBox(height: 20),
              buildDepositButton(context, Icons.phone_android,
                  'Internet/Mobile Banking', mobileBankingPage()),
              SizedBox(height: 20),
              buildDepositButton(
                  context, Icons.card_giftcard, 'Giftcode', giftcodePage()),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, Widget page) { // Fungsi pindah page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget buildDepositButton(
      BuildContext context, IconData icon, String label, Widget page) { // Buat tombol-tombol
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            navigateToPage(context, page);
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 230, 15, 122),
            minimumSize: Size(50, 70),
            padding: const EdgeInsets.all(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Icon(
                icon,
                color: Color.fromARGB(255, 94, 3, 48),
                size: 40,
              ),
              SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PoppinsBold',
                    color: Color.fromARGB(255, 94, 3, 48)),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
