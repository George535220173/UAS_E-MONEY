import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';
import 'package:uas_emoney/pin.dart';

class debitPage extends StatefulWidget {
  const debitPage({Key? key}) : super(key: key);

  @override
  _debitPageState createState() => _debitPageState();
}

class _debitPageState extends State<debitPage> {
  String selectedAmount = '100,000';
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String cardNumberError = '';
  String cvvError = '';
  FocusNode cardNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    cardNumberFocusNode.addListener(() {
      if (!cardNumberFocusNode.hasFocus) {
        setState(() {
          cardNumberError = _validateCardNumber(cardNumberController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 22, 138),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 65),
            Text(
              'Choose Amount',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: Color.fromARGB(255, 134, 255, 154),
                  fontFamily: 'PoppinsBold'),
            ),
            SizedBox(height: 10),
            buildAmountDropdown(),
            SizedBox(height: 40),
            Text(
              'Card Information',
              style: TextStyle(
                  fontSize: 26.0,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 134, 255, 154)),
            ),
            SizedBox(height: 10),
            buildCardInfoField('Card Number', 16, cardNumberError),
            SizedBox(height: 30),
            buildExpirationDateFields(),
            SizedBox(height: 20),
            buildCardInfoField('CVV', 3, cvvError),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinCodeWidget(
                      onPinVerified: () {
                        Navigator.pop(context);
                        depositAmount();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text(
                                  'Rp. $selectedAmount has been added to your balance.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Incorrect PIN'),
                              content: Text('The entered PIN is incorrect.'),
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
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                primary: Color.fromARGB(255, 134, 255, 154),
                minimumSize: Size(50, 10)
              ),
              child: Text(
                'Deposit',
                style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 28,
                    color: Color.fromARGB(255, 73, 37, 190)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAmountDropdown() {
    return DropdownButton<String>(
      dropdownColor: Color.fromARGB(255, 44, 19, 119),
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
          child: Text(
            value,
            style: TextStyle(
                fontFamily: 'PoppinsRegular',
                fontSize: 20,
                color: Color.fromARGB(255, 134, 255, 154)),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCardInfoField(String labelText, int maxLength, String errorText) {
    return TextField(
        controller:
            labelText == 'Card Number' ? cardNumberController : cvvController,
        focusNode: labelText == 'Card Number' ? cardNumberFocusNode : null,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        onChanged: (text) {
          if (labelText == 'CVV') {
            setState(() {
              cvvError = _validateCVV(text);
            });
          }
        },
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Color.fromARGB(255, 134, 255, 154),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 134, 255, 154), width: 3.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorText: errorText,
        ),
        style: TextStyle(
            fontFamily: 'PoppinsBold',
            fontSize: 20,
            color: Color.fromARGB(255, 73, 37, 190)));
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
                      filled: true,
                      fillColor: Color.fromARGB(255, 134, 255, 154),
                      labelText: 'Month',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 134, 255, 154),
                            width: 3.5),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 20,
                      color: Color.fromARGB(255, 73, 37, 190))),
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
                      filled: true,
                      fillColor: Color.fromARGB(255, 134, 255, 154),
                      labelText: 'Year',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 134, 255, 154),
                            width: 3.5),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 20,
                      color: Color.fromARGB(255, 73, 37, 190))),
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
    String cardNumber = _getCardInfoFieldValue('Card Number');
    String expirationMonth = monthController.text;
    String expirationYear = yearController.text;
    String cvv = _getCardInfoFieldValue('CVV');

    cardNumberError = _validateCardNumber(cardNumber);
    cvvError = _validateCVV(cvv);

    if (cardNumberError.isEmpty &&
        cvvError.isEmpty &&
        expirationMonth.isNotEmpty &&
        expirationYear.isNotEmpty) {
      double amount = double.parse(selectedAmount.replaceAll(',', ''));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Balance has been updated.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Done!'),
              ),
            ],
          );
        },
      );
      Money.deposit(amount);

      String transactionDescription = 'Deposit ke $cardNumber';
      Money.transactionHistory.add(Transaction(
          type: transactionDescription, amount: amount, date: DateTime.now()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete or Invalid Card Information'),
            content: Text('Please fill in all fields correctly.'),
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

  String _getCardInfoFieldValue(String labelText) {
    if (labelText == 'Card Number') {
      return cardNumberController.text;
    } else if (labelText == 'CVV') {
      return cvvController.text;
    }
    return '';
  }

  String _validateCardNumber(String cardNumber) {
    if (cardNumber.length != 16) {
      return 'Card number must be 16 digits';
    }
    return '';
  }

  String _validateCVV(String cvv) {
    if (cvv.length != 3) {
      return 'CVV must be 3 digits';
    }
    return '';
  }
}
