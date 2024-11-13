import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:github_timeline/models/models.dart';
import 'package:github_timeline/utils/constants.dart';

///
/// RenderObjectWidget for the TransactionTimelineWidget
///
class TransactionTimelineWidget extends LeafRenderObjectWidget {
  ///
  /// Constructor for the TransactionTimelineWidget
  ///
  const TransactionTimelineWidget({
    required this.cycleStartDate,
    required this.transactions,
    required this.showLastDaycount,
    required this.rows,
    super.key,
    this.onTapCallback,
    this.showFullyear = false,
  });

  ///
  ///  the start date of the billing cycle
  ///
  final DateTime cycleStartDate;

  ///
  /// the list of transactions for each day
  ///
  final List<Transaction> transactions;

  ///
  /// the total number of days to show
  ///
  final int showLastDaycount;

  ///
  /// the number of rows in the grid
  ///
  final int rows;

  ///
  /// An onTap callback for the Grid item
  ///
  final Function(int index)? onTapCallback;

  ///
  /// showFullYear
  ///
  final bool showFullyear;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TransactionTimelineRenderBox(
      cycleStartDate: cycleStartDate,
      transactions: transactions,
      daysInMonth: showLastDaycount,
      onTapCallback: onTapCallback,
      rows: rows,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant TransactionTimelineRenderBox renderObject,
  ) {
    renderObject
      ..cycleStartDate = cycleStartDate
      ..rows = rows
      ..transactions = transactions
      ..daysInMonth = showLastDaycount
      ..onTapCallback = onTapCallback;
  }
}

///
/// Render Box for the TimeLine Widget
class TransactionTimelineRenderBox extends RenderBox {
  ///
  /// Constructor for the TransactionTimelineRenderBox
  ///
  TransactionTimelineRenderBox({
    required this.cycleStartDate,
    required this.transactions,
    required this.daysInMonth,
    this.onTapCallback,
    this.rows = 7,
  });

  /// Start date of the Credit card cycle
  DateTime cycleStartDate;

  ///
  /// List of transactions to render on the Gridview
  ///
  List<Transaction> transactions;

  ///
  ///  the total number of days to show
  ///
  int daysInMonth;

  ///
  /// Number of rows in the grid
  ///
  int rows;

  ///
  /// on tap callback for the grid tile
  ///
  Function(int index)? onTapCallback;

  final double _cellSpacing = 1.2;
  double _cellSize = 10;
  final double _headerHeight = 20;

  @override
  void performLayout() {
    final availableWidth = constraints.constrainWidth();
    const columns = 7; // Fixed to 7 columns for days of the week
    final rows = (daysInMonth / columns)
        .ceil(); // Calculate number of rows based on total days

    _cellSize = (availableWidth - (_cellSpacing * (columns - 1))) / columns * 0.99;

    final totalWidth = columns * (_cellSize + _cellSpacing) - _cellSpacing;
    final totalHeight =
        rows * (_cellSize + _cellSpacing) + _headerHeight - _cellSpacing;

    size = constraints.constrain(Size(totalWidth, totalHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    const columns = 7; // Fixed number of columns
    final rows = (daysInMonth / columns)
        .ceil(); // Calculate number of rows based on total days
    final cycleEndDate = cycleStartDate
        .add(Duration(days: daysInMonth - 1)); // End date of billing cycle

    // Determine the starting day of the week
    final startWeekdayIndex = cycleStartDate.weekday % 7; // Make Sunday = 0
    const weekdays = <String>[
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    final rotatedWeekdays = <String>[
      ...weekdays.sublist(startWeekdayIndex),
      ...weekdays.sublist(0, startWeekdayIndex),
    ];

    // Draw the weekday headers
    final headerStyle =
        TextStyle(color: Colors.white, fontSize: _cellSize * 0.2);

    for (var col = 0; col < columns; col++) {
      final x = offset.dx + col * (_cellSize + _cellSpacing);
      final textPainter = TextPainter(
        
        text: TextSpan(text: rotatedWeekdays[col], style: headerStyle),
        textDirection: TextDirection.ltr,
        
      );
      textPainter.layout(maxWidth: _cellSize);
      final textOffset = Offset(
        x + (_cellSize - textPainter.width) / 2,
        offset.dy + (_headerHeight - textPainter.height) / 2,
      );

      textPainter.paint(canvas, textOffset);
    }

    // Draw the cells and check for transactions
    for (var i = 0; i < daysInMonth; i++) {
      final row = i ~/ columns;
      final col = i % columns;
      final x = offset.dx + col * (_cellSize + _cellSpacing);
      final y = offset.dy + _headerHeight + row * (_cellSize + _cellSpacing);

      final currentDate = cycleStartDate.add(Duration(days: i));

      // Find the transaction for the current date
      final transaction = transactions.firstWhere(
        (t) => _isSameDay(convertStringToDateTime(t.date), currentDate),
        orElse: () => Transaction(
          date: currentDate.toString(),
          totalAmount: 0,
          transactionDetails: [],
        ),
      );

      final color = _getColorForSpending(
        transaction.totalAmount,
        transaction.transactionDetails,
      );

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Drawing the each cell as a rectangle
      canvas.drawRect(
        Rect.fromLTWH(x, y, _cellSize, _cellSize),
        paint,
      );

      // Draw the day number in the center of each cell
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${currentDate.day}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: _cellSize * 0.2),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: _cellSize);
      final textOffset = Offset(
        x + (_cellSize - textPainter.width) / 2,
        y + (_cellSize - textPainter.height) / 2,
      );
    //  if(i ==0 || i == daysInMonth - 1){
      textPainter.paint(canvas, textOffset);
    // }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerUpEvent && onTapCallback != null) {
      const columns = 7; // Fixed number of columns
      final totalWidth = constraints.maxWidth;
      final cellWidth = (totalWidth - (_cellSpacing * (columns - 1))) / columns;
      final column =
          (event.localPosition.dx / (cellWidth + _cellSpacing)).floor();
      final row = ((event.localPosition.dy - _headerHeight) /
              (cellWidth + _cellSpacing))
          .floor();
      final index = row * columns + column;

      if (index >= 0 && index < daysInMonth) {
        onTapCallback!(index);
        return true;
      }
    }
    return false;
  }

  Color _getColorForSpending(
    double transactionAmount,
    List<TransactionDetail> transactionDetails,
  ) {
    if (transactionDetails.any((e) => e.type == ExpenseType.credit)) {
      return Colors.green;
    }

    if (transactionAmount == 0) {
      return Colors.orange[100]!; // No spending
    } else if (transactionAmount <= 20) {
      return Colors.orange[200]!; // Low spending
    } else if (transactionAmount <= 50) {
      return Colors.orange[300]!; // Moderate spending
    } else {
      return Colors.orange[700]!; // High spending
    }
  }
}
