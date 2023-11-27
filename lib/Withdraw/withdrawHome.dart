import 'package:flutter/material.dart';
import 'package:uas_emoney/Withdraw/withdraw.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal Options'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildWithdrawalButton(context, 'ATM Withdrawal', () {
            navigateToPage(context, WithdrawPage());
          }),
              SizedBox(height: 20),
              buildWithdrawalButton(context, 'Indomaret Withdrawal', () {
                _showIndomaretWithdrawalInstructions(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWithdrawalButton(BuildContext context, String buttonText, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 147, 76, 175),
          padding: const EdgeInsets.all(12.0),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Indomaret Withdrawal Instructions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text("> Go to the nearest Indomaret store."),
              SizedBox(height: 8),
              Text('> Ask the cashier for Wizdrawal service.'),
              SizedBox(height: 8),
              Text('> Provide your registered phone number.'),
              SizedBox(height: 8),
              Text('> Inform the cashier of the withdrawal amount.'),
              SizedBox(height: 8),
              Text('> Complete the transaction as guided by the cashier.'),
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
