import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_timeline/main.dart';
import 'package:github_timeline/mocktransactions.dart';
import 'package:github_timeline/transaction_graph.dart';

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
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = true;
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
                width: constraints.maxWidth,
                child: InteractiveViewer(
                  child: TransactionGraph(
                    transactions: mockTransactions,
                  ),
                ));
          },
        ));
  }
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
