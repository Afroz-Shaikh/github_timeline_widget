import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_timeline/main.dart';
import 'package:github_timeline/mocktransactions.dart';

class HorizontalPage extends StatefulWidget {
  const HorizontalPage({super.key});

  @override
  State<HorizontalPage> createState() => _HorizontalPageState();
}



class _HorizontalPageState extends State<HorizontalPage> {

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = true;
    return  Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
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
                                        daysInMonth: isHorizontal ? 365 :  30,
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
      )
    );
                      
                    
    
  }
}
  bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}