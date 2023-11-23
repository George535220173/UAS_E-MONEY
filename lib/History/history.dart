import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        child: FutureBuilder<List<Transaction>>(
          future: _getTransactionHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error loading transaction history');
            }

            List<Transaction>? transactionHistory = snapshot.data;

            if (transactionHistory == null || transactionHistory.isEmpty) {
              return Text('No transaction history available');
            }
            return _buildTransactionList(transactionHistory);
          },
        ),
      ),
    );
  }

    Future<List<Transaction>> _getTransactionHistory() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    firestore.DocumentReference userDocRef =
        firestore.FirebaseFirestore.instance.collection('users').doc(uid);

    firestore.QuerySnapshot historySnapshot =
        await userDocRef.collection('history').orderBy('date', descending: true).get();

    List<Transaction> transaction = historySnapshot.docs
        .map((doc) => Transaction(
              type: doc['type'],
              amount: doc['amount'],
              date: (doc['date'] as firestore.Timestamp).toDate(),
            ))
        .toList();
        return transaction;
        
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
        title: Text('${transaction.type}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${transaction.date.toString()}'),
            Text('Nominal: ${currencyFormatter.format(transaction.amount)}'),
          ],
        ),
        onTap: () {
        },
      ),
    );
  }
   Widget _buildTransactionList(List<Transaction> transactionHistory) {
    Map<String, List<Transaction>> transactionsByDate = {};

    for (var transaction in transactionHistory) {
      final dateKey = DateFormat('dd/MM/yyyy').format(transaction.date);
      transactionsByDate.putIfAbsent(dateKey, () => []);
      transactionsByDate[dateKey]!.add(transaction);
    }

    List<String> sortedDates = transactionsByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length * 2 - 1,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider();
        }

        final dateIndex = index ~/ 2;
        final dateKey = sortedDates[dateIndex];
        final transactionsForDate = transactionsByDate[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                dateKey,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...transactionsForDate.map((transaction) => buildTransactionCard(transaction)),
          ],
        );
      },
    );
  }
}