import 'package:flutter/material.dart';
import 'package:uas_emoney/Withdraw/withdraw.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Withdrawal Options',
          style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 26),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildWithdrawalButton(context, 'ATM Withdrawal', () {
                navigateToPage(context, WithdrawPage());
              }),
              SizedBox(height: 80),
              buildWithdrawalButton(context, 'Indomaret Withdrawal', () {
                _showIndomaretWithdrawalInstructions(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWithdrawalButton(
      BuildContext context, String buttonText, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 230, 15, 122),
          minimumSize: Size(50, 70),
          padding: const EdgeInsets.all(12.0),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 26,
              fontFamily: 'PoppinsBold',
              color: Color.fromARGB(255, 94, 3, 48)),
        ),
      ),
    );
  }

  void _showATMWithdrawalInstructions(BuildContext context) {
    // Implement the instructions for ATM withdrawal here
    // You can use a similar approach as shown in your previous code
  }

  void _showIndomaretWithdrawalInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 210, 210)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Indomaret Withdrawal Instructions',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'PoppinsRegular'),
              ),
              SizedBox(height: 10),
              Text(
                "> Go to the nearest Indomaret store.",
                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
              ),
              SizedBox(height: 8),
              Text(
                '> Ask the cashier for Wizdrawal service.',
                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
              ),
              SizedBox(height: 8),
              Text(
                '> Provide your registered phone number.',
                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
              ),
              SizedBox(height: 8),
              Text(
                '> Inform the cashier of the withdrawal amount.',
                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
              ),
              SizedBox(height: 8),
              Text(
                '> Complete the transaction as guided by the cashier.',
                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
