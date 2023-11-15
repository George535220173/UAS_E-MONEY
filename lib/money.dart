class Money {
  static double totalBalance = 0.0;
  static Function()? onBalanceChange;

  static void deposit(double amount) {
    totalBalance += amount;
    if (onBalanceChange != null) {
      onBalanceChange!();
    }
  }
}
