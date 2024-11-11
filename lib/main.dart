import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:github_timeline/horizontal_page.dart';
import 'package:github_timeline/mocktransactions.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

DateTime kcycleStartDate = DateTime.now().subtract(const Duration(days: 35));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: const Size(600, 10),
                child: Divider(
                  color: Colors.white.withOpacity(0.2),
                )),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.orangeAccent,
            title: const Text(
              'Hi, Afroz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Tooltip(
                    key: _tooltipKey, // Assign the key here

                    triggerMode: TooltipTriggerMode.manual,
                    message: 'Switch to horizontal view',
                    child: GestureDetector(
                      onTap: () {
                        // SystemChrome.setPreferredOrientations(
                        //     [DeviceOrientation.landscapeRight]);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return const HorizontalPage();
                        }));
                      },
                      child: const Icon(
                        Icons.north_east,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Stack(
            children: [
              Builder(
                builder: (context) {
                  bool isHorizontal = MediaQuery.of(context).size.width > 600;
                  return SizedBox(
                    // color: Colors.red,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'Current Billing Cycle Spedings ${kcycleStartDate.difference(DateTime.now()).inDays} days left',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: SingleChildScrollView(
                                  scrollDirection: isHorizontal
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  child: RotatedBox(
                                    quarterTurns: isHorizontal ? 3 : 0,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth,
                                        maxHeight: isHorizontal
                                            ? double.maxFinite
                                            : 400,
                                      ),
                                      child: TransactionTimelineWidget(
                                        cycleStartDate: kcycleStartDate,
                                        transactions: mockTransactions,
                                        showLastDaycount:
                                            isHorizontal ? 100 : 40,
                                        rows: isHorizontal ? 10 : 7,
                                        onTapCallback: (index) {
                                          final cycleStartDate =
                                              kcycleStartDate;
                                          final DateTime selectedDate =
                                              cycleStartDate
                                                  .add(Duration(days: index));

                                          // Find the transaction for the selected date
                                          final transaction =
                                              mockTransactions.firstWhere(
                                            (t) => _isSameDay(
                                                DateTime.parse(t.date),
                                                selectedDate), // Use _isSameDay to compare dates
                                            orElse: () => Transaction(
                                                date: selectedDate.toString(),
                                                totalAmount: 0,
                                                transactionDetails: []),
                                          );

                                          // Show the dialog with the correct transaction details
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: SizedBox(
                                                  height: 200,
                                                  width: 300,
                                                  child: ListView.builder(
                                                    itemCount: transaction
                                                        .transactionDetails
                                                        .length,
                                                    itemBuilder: (context, i) {
                                                      return ListTile(
                                                        title: Text(transaction
                                                            .transactionDetails[
                                                                i]
                                                            .merchant),
                                                        subtitle: Text(transaction
                                                            .transactionDetails[
                                                                i]
                                                            .category),
                                                        trailing: Text(
                                                            "\$${transaction.transactionDetails[i].amount.toStringAsFixed(2)}"),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Available Limit',
                                  style: TextStyle(color: Colors.white)),
                              const SizedBox(
                                height: 5,
                              ),
                              LinearProgressIndicator(
                                value: 0.7,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.orangeAccent),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          textColor: Colors.grey,
                          title: Text(
                            'Statement Summary',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {},
                              child: Text('View')),
                          subtitle: Text('for the month November 2024'),
                        )
                      ],
                    ),
                  );
                },
              ),
              DraggableScrollableSheet(
                snap: true,
                initialChildSize: 0.4,
                snapSizes: [0.4, 0.6],
                minChildSize: 0.4,
                builder: (BuildContext context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      color: Color(0xff111111),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverList.list(children: [
                          const Divider(
                            color: Colors.white,
                            thickness: 0.2,
                            endIndent: 120,
                            indent: 120,
                          ),
                          ListTile(
                            trailing: Text(mockTransactions
                                .map((e) => e.totalAmount)
                                .reduce((value, element) => value + element)
                                .toStringAsFixed(2)),
                            title: Text(
                              'Recent Transactions',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...mockTransactions.reversed.map((transaction) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 54, 54, 54)!),
                              ),
                              child: ListTile(
                                  dense: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  minLeadingWidth: 7,
                                  leading: GestureDetector(
                                      child: const Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 10,
                                  )),
                                  trailing: Text(
                                    transaction.date.toString(),
                                  ),
                                  title: Text(transaction.transactionDetails
                                      .map((e) => e.merchant)
                                      .join(", ")),
                                  subtitle: Text(
                                    transaction.totalAmount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )),
                            );
                          })
                        ])
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Transaction class for each day's transaction
class Transaction {
  final String date;
  final double totalAmount;
  final List<TransactionDetail> transactionDetails;

  Transaction({
    required this.date,
    required this.totalAmount,
    required this.transactionDetails,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var list = json['transactions'] as List;
    List<TransactionDetail> transactionList =
        list.map((i) => TransactionDetail.fromJson(i)).toList();
    return Transaction(
      date: json['date'],
      totalAmount: json['totalAmount'],
      transactionDetails: transactionList,
    );
  }
}

DateTime convertStringToDateTime(String dateString) {
  return DateTime.parse(dateString);
}

enum ExpenseType { credit, debit }

// Transaction class for each day's transaction
class TransactionDetail {
  final String merchant;
  final double amount;
  final String category;
  final ExpenseType type; // "credit" or "debit"

  TransactionDetail({
    required this.merchant,
    required this.amount,
    required this.category,
    this.type = ExpenseType.debit, // Include this field
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      merchant: json['merchant'],
      amount: json['amount'],
      category: json['category'],
      type: json['type'], // Ensure 'type' is included in the JSON parsing
    );
  }
}

class TransactionTimelineWidget extends LeafRenderObjectWidget {
  final DateTime cycleStartDate;
  final List<Transaction>
      transactions; // A list of transactions (one for each day)
  final int showLastDaycount; // Total number of days to show
  final int rows; // Number of rows in the grid
  final Function(int index)? onTapCallback;
  final bool showFullyear;

  const TransactionTimelineWidget({
    super.key,
    required this.cycleStartDate,
    required this.transactions,
    required this.showLastDaycount,
    required this.rows,
    this.onTapCallback,
    this.showFullyear = false,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TransactionTimelineRenderBox(
        cycleStartDate: cycleStartDate,
        transactions: transactions,
        daysInMonth: showLastDaycount,
        onTapCallback: onTapCallback,
        rows: rows);
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant TransactionTimelineRenderBox renderObject) {
    renderObject
      ..cycleStartDate = cycleStartDate
      ..rows = rows
      ..transactions = transactions
      ..daysInMonth = showLastDaycount
      ..onTapCallback = onTapCallback;
  }
}

class TransactionTimelineRenderBox extends RenderBox {
  DateTime cycleStartDate;
  List<Transaction> transactions;
  int daysInMonth;
  int rows;
  Function(int index)? onTapCallback;

  TransactionTimelineRenderBox({
    required this.cycleStartDate,
    required this.transactions,
    required this.daysInMonth,
    this.onTapCallback,
    this.rows = 7,
  });

  double _cellSpacing = 1.2;
  double _cellSize = 10.0;
  double _headerHeight = 20.0; // Height of the header row

  @override
  void performLayout() {
    final double availableWidth = constraints.constrainWidth();
    final int columns = 7; // Fixed to 7 columns for days of the week
    final int rows = (daysInMonth / columns)
        .ceil(); // Calculate number of rows based on total days

    _cellSize = (availableWidth - (_cellSpacing * (columns - 1))) / columns;

    final double totalWidth =
        columns * (_cellSize + _cellSpacing) - _cellSpacing;
    final double totalHeight =
        rows * (_cellSize + _cellSpacing) + _headerHeight - _cellSpacing;

    size = constraints.constrain(Size(totalWidth, totalHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    const int columns = 7; // Fixed number of columns
    final int rows = (daysInMonth / columns)
        .ceil(); // Calculate number of rows based on total days
    final DateTime cycleEndDate = cycleStartDate
        .add(Duration(days: daysInMonth - 1)); // End date of billing cycle

    // Determine the starting day of the week
    final int startWeekdayIndex = cycleStartDate.weekday % 7; // Make Sunday = 0
    const List<String> weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];
    final List<String> rotatedWeekdays = [
      ...weekdays.sublist(startWeekdayIndex),
      ...weekdays.sublist(0, startWeekdayIndex)
    ];

    // Draw the weekday headers
    final TextStyle headerStyle =
        TextStyle(color: Colors.white, fontSize: _cellSize * 0.2);

    for (int col = 0; col < columns; col++) {
      final double x = offset.dx + col * (_cellSize + _cellSpacing);
      final textPainter = TextPainter(
        text: TextSpan(text: rotatedWeekdays[col], style: headerStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: _cellSize);
      final textOffset = Offset(
        x + (_cellSize - textPainter.width) / 2,
        offset.dy + (_headerHeight - textPainter.height) / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Draw the cells and check for transactions
    for (int i = 0; i < daysInMonth; i++) {
      final int row = i ~/ columns;
      final int col = i % columns;
      final double x = offset.dx + col * (_cellSize + _cellSpacing);
      final double y =
          offset.dy + _headerHeight + row * (_cellSize + _cellSpacing);

      final DateTime currentDate = cycleStartDate.add(Duration(days: i));

      // Find the transaction for the current date
      final transaction = transactions.firstWhere(
        (t) => _isSameDay(convertStringToDateTime(t.date), currentDate),
        orElse: () => Transaction(
            date: currentDate.toString(),
            totalAmount: 0,
            transactionDetails: []),
      );

      Color color = _getColorForSpending(
        transaction.totalAmount,
        transaction.transactionDetails,
      );

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw each cell as a rectangle
      canvas.drawRect(
        Rect.fromLTWH(x, y, _cellSize, _cellSize),
        paint,
      );

      // Draw the day number in the center of each cell
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${currentDate.day}',
          style: TextStyle(color: Colors.black, fontSize: _cellSize * 0.3),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: _cellSize);
      final textOffset = Offset(
        x + (_cellSize - textPainter.width) / 2,
        y + (_cellSize - textPainter.height) / 2,
      );
      textPainter.paint(canvas, textOffset);
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
      const int columns = 7; // Fixed number of columns
      final double totalWidth = constraints.maxWidth;
      final double cellWidth =
          (totalWidth - (_cellSpacing * (columns - 1))) / columns;
      final int column =
          (event.localPosition.dx / (cellWidth + _cellSpacing)).floor();
      final int row = ((event.localPosition.dy - _headerHeight) /
              (cellWidth + _cellSpacing))
          .floor();
      final int index = row * columns + column;

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

    print(transactionAmount.toString() + "\n");
    if (transactionAmount == 0) {
      return Colors.grey[200]!; // No spending
    } else if (transactionAmount <= 20) {
      return Colors.orange[100]!; // Low spending
    } else if (transactionAmount <= 50) {
      return Colors.orange[300]!; // Moderate spending
    } else {
      return Colors.orange[700]!; // High spending
    }
  }
}
