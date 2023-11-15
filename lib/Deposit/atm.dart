import 'package:flutter/material.dart';

class atmPage extends StatelessWidget {
  const atmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit with ATM'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Icon(Icons.money, size: 200, color: Color.fromARGB(255, 147, 76, 175)),
              SizedBox(height: 20),
              buildElevatedButton(context, 'BCA'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'BNI'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'BRI'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'MANDIRI'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButton(BuildContext context, String bankName) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showExtraPage(context, bankName);
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 147, 76, 175),
          padding: const EdgeInsets.all(12.0),
        ),
        child: Text(
          bankName,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showExtraPage(BuildContext context, String bankName) {
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
                'Istruction for $bankName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              if (bankName == 'BCA') ...[
                _instruksiBCA()
              ] else if (bankName == 'BRI') ...[
                _instruksiBRI()
              ] else if (bankName == 'BNI') ...[
                _instruksiBNI()
              ] else ...[
                _instruksiMANDIRI()
              ]
            ],
          ),
        );
      },
    );
  }

  Column _instruksiBCA() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> bcaaaaa'),
        Text('> 1blabla'),
        Text('> 1blabla'),
      ],
    );
  }
  Column _instruksiBNI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> bniii'),
        Text('> 1blabla'),
        Text('> 1blabla'),
      ],
    );
  }
  Column _instruksiBRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> briiii'),
        Text('> 1blabla'),
        Text('> 1blabla'),
      ],
    );
  }
  Column _instruksiMANDIRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> mandiriii'),
        Text('> 1blabla'),
        Text('> 1blabla'),
      ],
    );
  }
}
