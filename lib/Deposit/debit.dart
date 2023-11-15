import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_emoney/money.dart';

class debitPage extends StatefulWidget {
  const debitPage({Key? key}) : super(key: key);

  @override
  _debitPageState createState() => _debitPageState();
}

class _debitPageState extends State<debitPage> {
  String selectedAmount = '100,000'; // Default selected amount
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit with Debit Visa/Mastercard'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            buildAmountDropdown(),
            SizedBox(height: 20),
            Text(
              'Card Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            buildCardInfoField('Card Number', 16),
            SizedBox(height: 10),
            buildExpirationDateFields(),
            SizedBox(height: 10),
            buildCardInfoField('CVV', 3),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                depositAmount(); // Call the deposit function
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 76, 175),
                padding: const EdgeInsets.all(12.0),
              ),
              child: Text(
                'Deposit',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAmountDropdown() {
    return DropdownButton<String>(
      value: selectedAmount,
      onChanged: (String? newValue) {
        setState(() {
          selectedAmount = newValue!;
        });
      },
      items: ['100,000', '200,000', '500,000', '1,000,000']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildCardInfoField(String labelText, int maxLength) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildExpirationDateFields() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _selectMonth(context);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: monthController,
                decoration: InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _selectYear(context);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectMonth(BuildContext context) async {
    final List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    int? selectedMonth = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Month'),
          children: List.generate(
            12,
            (index) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, index + 1);
              },
              child: Text(monthNames[index]),
            ),
          ),
        );
      },
    );

    if (selectedMonth != null) {
      monthController.text = selectedMonth.toString();
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Year'),
          children: List.generate(
            11,
            (index) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, DateTime.now().year + index);
              },
              child: Text('${DateTime.now().year + index}'),
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      yearController.text = selectedYear.toString();
    }
  }

  void depositAmount() {
    double amount = double.parse(selectedAmount.replaceAll(',', ''));
    Money.deposit(amount);
  }
}
