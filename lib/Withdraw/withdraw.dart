import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';
import 'package:uas_emoney/pin.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  String selectedAmount = '';

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
      backgroundColor: Color.fromARGB(255, 51, 22, 138),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Withdraw Amount',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: 'Rp. $selectedAmount'),
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 134, 255, 154)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 73, 37, 190),
                hintText: 'Select nominal amount',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 134, 255, 154), 
                      width: 3.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () {
                _showNominalDialog(context);
              },
            ),
            SizedBox(height: 60),
            Text(
              'Jumlah Tunai',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 134, 255, 154)),
            ),
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
                if (selectedAmount.isNotEmpty) {
                  double withdrawAmount =
                      double.tryParse(selectedAmount.replaceAll('Rpp. ', '')) ??
                          0.0;
                  if (withdrawAmount > 0 &&
                      withdrawAmount <= Money.totalBalance) {
                    // Money.withdraw(withdrawAmount);

                    // Money.transactionHistory.add(Transaction(
                    //     type: 'Withdraw',
                    //     amount: withdrawAmount,
                    //     date: DateTime.now()));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PinCodeWidget(
                          onPinVerified: () {
                            Money.withdraw(withdrawAmount);

                            Money.transactionHistory.add(Transaction(
                                type: 'Withdraw',
                                amount: withdrawAmount,
                                date: DateTime.now()));

                            Navigator.pop(context);
                            // This function is called when PIN is verified successfully
                            // You can place your transaction completion logic here
                            // For example, you can show a success dialog or navigate to a success screen.

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content: Text(
                                      'Rp.$withdrawAmount has been deducted from your balance.'),
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
                            // This function is called when PIN is incorrect
                            // You can handle incorrect PIN logic here, for example, show an error message
                            // and reset any changes made during the PIN entry
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Incorrect PIN'),
                                  content:
                                      Text('The entered PIN is incorrect.'),
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
                  } else {
                    double balanceShort = withdrawAmount - Money.totalBalance;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Not enough balance'),
                          content: Text(
                              'You are Rp.$balanceShort short from being able to withdraw.'),
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
                  }
                } else {
                  print('Pilih nominal untuk penarikan');
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                primary: Color.fromARGB(255, 134, 255, 154),
                minimumSize: Size(50, 10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Withdraw',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 28,
                    color: Color.fromARGB(255, 73, 37, 190)
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
          color: Color.fromARGB(255, 73, 37, 190),
          border:
              Border.all(color: Color.fromARGB(255, 134, 255, 154), width: 3.5),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            'Rp. ${double.parse(nominalValues[index]).toStringAsFixed(0)}',
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'PoppinsBold',
                color: Color.fromARGB(255, 134, 255, 154)),
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
}
