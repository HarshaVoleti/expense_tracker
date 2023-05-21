import 'package:expense_tracker/Chart.dart';
import 'package:expense_tracker/TransactionList.dart';
import 'package:expense_tracker/newtransaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/Transactions.dart';
import 'dart:io';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Expenses",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.black,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline5: TextStyle(
                  fontFamily: 'Opensans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline5: TextStyle(
                    fontFamily: 'Opensans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      debugShowCheckedModeBanner: false,
      home: Balance(),
    );
  }
}

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> with WidgetsBindingObserver {
// list of demo transactions
  final List<Transactions> transactions = [
    // Transactions(
    //   id: DateTime.now().toString(),
    //   title: 'new shirt',
    //   amount: 99,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transactions> get _recentTransactions {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transactions(
      title: txTitle,
      amount: txAmount,
      date: date,
      id: DateTime.now().toString(),
    );
    setState(() {
      transactions.add(newTx);
    });
  }

  void _addTransactionpage(ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void removeTransaction(String id) {
    setState(() {
      transactions.removeWhere(
        (transactions) => transactions.id == id,
      );
    });
  }

  bool showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //switch varialble
    final swtch = Switch.adaptive(
        activeColor: Colors.blue,
        value: showChart,
        onChanged: (val) {
          setState(() {
            showChart = val;
          });
        });
    final mediaquery = MediaQuery.of(context);

    final landscape = mediaquery.orientation == Orientation.landscape;

    //appBar variable
    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "My Expenses",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      actions: [
        if (landscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('show Chart', style: Theme.of(context).textTheme.headline5),
              swtch,
            ],
          ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () => _addTransactionpage(context),
        ),
      ],
    );
    //transaction list variable
    final txlist = Container(
      height: (mediaquery.size.height -
              appBar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: TransactionList(transactions, removeTransaction),
    );

    //pagebody variable
    final pagebody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('show Chart',
                      style: Theme.of(context).textTheme.headline5),
                  swtch,
                ],
              ),
            if (!landscape)
              Container(
                height: (mediaquery.size.height -
                        appBar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!landscape) txlist,
            if (landscape)
              showChart
                  ? Container(
                      height: (mediaquery.size.height -
                              appBar.preferredSize.height -
                              mediaquery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txlist,
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 249, 253, 1),
      appBar: appBar,
      body: pagebody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _addTransactionpage(context),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              backgroundColor: Colors.white,
            ),
    );
  }
}
