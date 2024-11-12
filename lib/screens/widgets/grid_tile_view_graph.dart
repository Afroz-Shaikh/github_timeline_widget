import 'package:flutter/material.dart';
import 'package:github_timeline/models/models.dart';
import 'package:github_timeline/utils/constants.dart';

///
/// GridTileViewGraph widget to display the yearly transaction graph
///
class GridTileViewGraph extends StatefulWidget {
  /// constructor for the TransactionGraph class
  const GridTileViewGraph({required this.transactions, super.key});

  /// list of transactions
  final List<Transaction> transactions;

  @override
  _GridTileViewGraphState createState() => _GridTileViewGraphState();
}

class _GridTileViewGraphState extends State<GridTileViewGraph> {
  late final Map<String, double> _transactionMap;
  late final Map<String, bool> _hasCreditTransactionMap;

  @override
  void initState() {
    super.initState();
    _transactionMap = _aggregateTransactions(widget.transactions);
    _hasCreditTransactionMap = _checkCreditTransactions(widget.transactions);
  }

  Map<String, double> _aggregateTransactions(List<Transaction> transactions) {
    final transactionMap = <String, double>{};
    for (final transaction in transactions) {
      transactionMap[transaction.date] = transaction.totalAmount;
    }
    return transactionMap;
  }

  Map<String, bool> _checkCreditTransactions(List<Transaction> transactions) {
    final creditMap = <String, bool>{};
    for (final transaction in transactions) {
      final hasCredit = transaction.transactionDetails
          .any((detail) => detail.type == ExpenseType.credit);
      creditMap[transaction.date] = hasCredit;
    }
    return creditMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yearly Transaction Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _buildGraph(),
      ),
    );
  }

  Widget _buildGraph() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year - 1, now.month, now.day);
    final blocks = <Widget>[];

    for (var i = 0; i < 365; i++) {
      final currentDate = firstDayOfYear.add(Duration(days: i));
      final dateString = formatDate(currentDate);
      final amountSpent = _transactionMap[dateString] ?? 0.0;
      final isCreditDay = _hasCreditTransactionMap[dateString] ?? false;

      final color = isCreditDay
          ? Colors.green
          : Color.lerp(
              Colors.orange[100],
              Colors.orange[900],
              (amountSpent / 100).clamp(0.0, 1.0),
            )!;

      blocks.add(
        GestureDetector(
          onTap: () =>
              _showTransactionsDialog(context, currentDate, amountSpent),
          child: Container(
            margin: const EdgeInsets.all(1),
            width: 10,
            height: 10,
            color: color,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: blocks,
    );
  }

  void _showTransactionsDialog(
    BuildContext context,
    DateTime date,
    double amountSpent,
  ) {
    final dateString = formatDate(date);
    final transactions = widget.transactions
        .where((transaction) => transaction.date == dateString)
        .expand((transaction) => transaction.transactionDetails)
        .toList();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transactions on $dateString'),
          content: transactions.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: transactions
                      .map(
                        (detail) => ListTile(
                          title: Text(detail.merchant),
                          subtitle:
                              Text('\$${detail.amount.toStringAsFixed(2)}'),
                        ),
                      )
                      .toList(),
                )
              : const Text('No transactions recorded for this day.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
