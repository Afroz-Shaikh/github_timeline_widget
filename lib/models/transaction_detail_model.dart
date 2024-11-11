import 'package:github_timeline/utils/constants.dart';

/// TransactionDetail class for each day's transaction
class TransactionDetail {
  // "credit" or "debit"

  /// Constructor for the TransactionDetail class
  TransactionDetail({
    required this.merchant,
    required this.amount,
    required this.category,
    this.type = ExpenseType.debit, // Include this field
  });

  ///
  /// fromJson method for converting the JSON object to a TransactionDetail
  ///
  /// object
  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      merchant: json['merchant'] as String,
      amount: json['amount'] as double,
      category: json['category'] as String,
      type: json['type'] as ExpenseType,
    );
  }

  ///
  /// the merchant or the thing that the transaction was made for
  ///
  final String merchant;

  ///
  /// the amount of the transaction
  ///
  final double amount;

  ///
  /// the category of the transaction
  ///
  final String category;

  ///
  /// the type of the transaction
  ///
  final ExpenseType type;
}
