
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.orangeAccent,
            title:  const  Text('Hi, Afroz',style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
          actions: const  [
            DecoratedBox(
              
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
               
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.north_east,color: Colors.black,
                  size: 14,
                  
                  ),
              ),
            ),
             SizedBox(width: 10,),
          ],
          
          ),

          body: Stack(
            children: [
              Builder(
                builder: (context) {
              bool    isHorizontal = MediaQuery.of(context).size.width > 600;
                  return Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: 400,
                            width: constraints.maxWidth,
                            child: SingleChildScrollView(
                              scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
                              child: RotatedBox(
                                quarterTurns: isHorizontal ? 3 : 0,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                    maxHeight: isHorizontal ? double.maxFinite : 400,
                                  ),
                                  child: TransactionTimelineWidget(
                                    cycleStartDate: DateTime.now().subtract(Duration(days: 180)),
                                    transactions: mockTransactions,
                                    daysInMonth: isHorizontal ? 100 :  30,
                                rows: 7,
                                    onTapCallback: (index) {
                                     final cycleStartDate =   DateTime.now().subtract(Duration(days: 180));
                                  final DateTime selectedDate = cycleStartDate.add(Duration(days: index));
                                
                                  // Find the transaction for the selected date
                                  final transaction = mockTransactions.firstWhere(
                                    (t) => _isSameDay(DateTime.parse(t.date), selectedDate), // Use _isSameDay to compare dates
                                    orElse: () => Transaction(date: selectedDate.toString(), totalAmount: 0, transactionDetails: []),
                                  );
                                
                                  // Show the dialog with the correct transaction details
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          height: 200,
                                          width: 300,
                                          child: ListView.builder(
                                            itemCount: transaction.transactionDetails.length,
                                            itemBuilder: (context, i) {
                                              return ListTile(
                                                title: Text(transaction.transactionDetails[i].merchant),
                                                subtitle: Text(transaction.transactionDetails[i].category),
                                                trailing: Text("\$${transaction.transactionDetails[i].amount.toStringAsFixed(2)}"),
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
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
          
         DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.6,
          minChildSize: 0.6,
  builder: (BuildContext context, scrollController) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration:const   BoxDecoration(
        color: Colors.white,
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList.list(children:  [
            const Divider(
              thickness: 0.1,
               endIndent: 70,
               indent: 70,
            ),
         ...mockTransactions.map((transaction){
            return ListTile(
              minLeadingWidth: 7,
              leading: const Icon(Icons.arrow_outward_rounded, size: 10,color: Colors.black,),
              trailing:  Text(transaction.date.toString(),style: const TextStyle(color: Colors.black),),
              title:  Text(transaction.totalAmount.toString(),style: const  TextStyle(color: Colors.black,fontSize: 12),));
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
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
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
// Transaction class for each day's transaction
class TransactionDetail {
  final String merchant;
  final double amount;
  final String category;

  TransactionDetail({
    required this.merchant,
    required this.amount,
    required this.category,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      merchant: json['merchant'],
      amount: json['amount'],
      category: json['category'],
    );
  }
}

class TransactionTimelineWidget extends LeafRenderObjectWidget {
  final DateTime cycleStartDate;
  final List<Transaction> transactions; // A list of transactions (one for each day)
  final int daysInMonth; // Total number of days to show
  final int rows; // Number of rows in the grid
  final Function(int index)? onTapCallback;

  const TransactionTimelineWidget({super.key, 
    required this.cycleStartDate,
    required this.transactions,
    required this.daysInMonth,
    required this.rows,
    this.onTapCallback,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TransactionTimelineRenderBox(
      cycleStartDate: cycleStartDate,
      transactions: transactions,
      daysInMonth: daysInMonth,
      onTapCallback: onTapCallback,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TransactionTimelineRenderBox renderObject) {
    renderObject
      ..cycleStartDate = cycleStartDate
      ..transactions = transactions
      ..daysInMonth = daysInMonth
      ..onTapCallback = onTapCallback;
  }
}

class TransactionTimelineRenderBox extends RenderBox {
  DateTime cycleStartDate;
  List<Transaction> transactions;
  int daysInMonth;
  Function(int index)? onTapCallback;

  TransactionTimelineRenderBox({
    required this.cycleStartDate,
    required this.transactions,
    required this.daysInMonth,
    this.onTapCallback,
  });

  double _cellSpacing = 1.2;
  double _cellSize = 10.0;
  double _headerHeight = 20.0; // Height of the header row

  @override
  void performLayout() {
    final double availableWidth = constraints.constrainWidth();
    final int columns = 7; // Fixed to 7 columns for days of the week
    final int rows = (daysInMonth / columns).ceil(); // Calculate number of rows based on total days

    _cellSize = (availableWidth - (_cellSpacing * (columns - 1))) / columns;

    final double totalWidth = columns * (_cellSize + _cellSpacing) - _cellSpacing;
    final double totalHeight = rows * (_cellSize + _cellSpacing) + _headerHeight - _cellSpacing;

    size = constraints.constrain(Size(totalWidth, totalHeight));
  }

@override
void paint(PaintingContext context, Offset offset) {
  final Canvas canvas = context.canvas;
  final int columns = 7; // Fixed to 7 columns
  final int rows = (daysInMonth / columns).ceil(); // Calculate number of rows based on total days
  final DateTime cycleEndDate = cycleStartDate.add(Duration(days: daysInMonth - 1)); // End date of billing cycle

  // Determine the starting day of the week
  final int startWeekdayIndex = cycleStartDate.weekday % 7; // Make Sunday = 0
  const List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> rotatedWeekdays = [
    ...weekdays.sublist(startWeekdayIndex),
    ...weekdays.sublist(0, startWeekdayIndex)
  ];

  // Draw the weekday headers
  final TextStyle headerStyle = TextStyle(color: Colors.white, fontSize: _cellSize * 0.2);

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
    final double y = offset.dy + _headerHeight + row * (_cellSize + _cellSpacing);

    final DateTime currentDate = cycleStartDate.add(Duration(days: i));
bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}
    // Find the transaction for the current date
    final transaction = transactions.firstWhere(
      (t) => _isSameDay(convertStringToDateTime(t.date), currentDate),
      orElse: () => Transaction(date: currentDate.toString(), totalAmount: 0, transactionDetails: []),
    );

    Color color = _getColorForSpending(transaction.totalAmount);

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



  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerUpEvent && onTapCallback != null) {
      final int columns = 7; // Fixed number of columns
      final double totalWidth = constraints.maxWidth;
      final double cellWidth = (totalWidth - (_cellSpacing * (columns - 1))) / columns;
      final int column = (event.localPosition.dx / (cellWidth + _cellSpacing)).floor();
      final int row = ((event.localPosition.dy - _headerHeight) / (cellWidth + _cellSpacing)).floor();
      final int index = row * columns + column;

      if (index >= 0 && index < daysInMonth) {
        onTapCallback!(index);
        return true;
      }
    }
    return false;
  }

  Color _getColorForSpending(double transactionAmount) {
    print(transactionAmount.toString() + "\n");
    if (transactionAmount == 0) {
      return Colors.grey[200]!; // No spending
    } else if (transactionAmount <= 20) {
      return Colors.green[100]!; // Low spending
    } else if (transactionAmount <= 50) {
      return Colors.green[300]!; // Moderate spending
    } else {
      return Colors.red[700]!; // High spending
    }
  }
}
