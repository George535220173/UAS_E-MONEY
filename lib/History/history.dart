import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/money.dart';
import 'package:intl/intl.dart';



// class TransactionHistoryPage extends StatelessWidget {
//   const TransactionHistoryPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transaction History'),
//         backgroundColor: Color.fromARGB(255, 147, 76, 175), // E-money theme color
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: List.generate(
//             10, // Number of transactions, replace it with your data
//             (index) => buildTransactionCard(index),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTransactionCard(int index) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.grey,
//           child: Icon(Icons.monetization_on, color: Colors.white),
//         ),
//         title: Text('Transaction #$index'),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Date: ${DateTime.now().toString()}'), // Replace with your date
//             Text('Amount: \$100.00'), // Replace with your amount
//           ],
//         ),
//         onTap: () {
//           // Handle tapping on a transaction, e.g., show details
//         },
//       ),
//     );
//   }
// }
class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: Money.transactionHistory.length,
          itemBuilder: (context, index) {
            return buildTransactionCard(Money.transactionHistory[index]);
          },
        ),
      ),
    );
  }

  Widget buildTransactionCard(Transaction transaction) {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.monetization_on, color: Colors.white),
      ),
      title: Text('${transaction.recipient}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${transaction.date.toString()}'),
          Text('Amount: ${currencyFormatter.format(transaction.amount)}'),
        ],
      ),
      onTap: () {
      },
    ),
  );
}

}
