class Transaction {
  final String type; // Sesuaikan dengan field yang ada di Firestore
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
  });
}