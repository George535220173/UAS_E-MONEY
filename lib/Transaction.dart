class Transaction {
  final String recipient; // Sesuaikan dengan field yang ada di Firestore
  final double amount;
  final DateTime date;

  Transaction({
    required this.recipient,
    required this.amount,
    required this.date,
  });
}