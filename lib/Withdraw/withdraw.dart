import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  String selectedAmount = ''; // Default amount

  List<String> nominalValues = [
    '50000',
    '100000',
    '200000',
    '300000',
    '500000',
    '1000000'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
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
              readOnly: true,
              controller: TextEditingController(text: 'Rp. $selectedAmount'),
              decoration: InputDecoration(
                hintText: 'Select nominal amount',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                _showNominalDialog(context);
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
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
              ),
              itemCount: nominalValues.length,
              itemBuilder: (context, index) {
                return _buildNominalContainer(index);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String type = 'Withdraw';
                // Implement withdrawal logic
                if (selectedAmount.isNotEmpty) {
                  double withdrawAmount =
                      double.tryParse(selectedAmount.replaceAll('Rpp. ', '')) ??
                          0.0;
                  if (withdrawAmount > 0 &&
                      withdrawAmount <= Money.totalBalance) {
                    Money.transfer(withdrawAmount);

                    Money.transactionHistory.add(Transaction(
                        type: type,
                        amount: withdrawAmount,
                        date: DateTime.now()));

                    _showSuccessMessage(type, withdrawAmount);

                    print('withdraw amount: $selectedAmount');
                  } else {
                    print('Invalid amount');
                  }
                } else {
                  print('Pilih nominal untuk penarikan');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175),
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

  Widget _buildNominalContainer(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = nominalValues[index];
        });
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            'Rp. ${double.parse(nominalValues[index]).toStringAsFixed(0)}',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  void _showNominalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Nominal Amount'),
          content: Column(
            children: nominalValues
                .map(
                  (value) => ListTile(
                    title:
                        Text('Rp. ${double.parse(value).toStringAsFixed(0)}'),
                    onTap: () {
                      setState(() {
                        selectedAmount = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _showSuccessMessage(String type, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('$type: ${Money.formatCurrency(amount)} berhasil'),
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
