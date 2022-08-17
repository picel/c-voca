import 'package:flutter/material.dart';
import 'package:CVoca/View/bookList.dart';
import 'package:CVoca/View/share.dart';
import 'package:CVoca/style.dart';
import 'package:CVoca/wordList.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: DefaultTabController(
        child: Home(),
        length: 3,
        initialIndex: 1,
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: SafeArea(
        child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(child: Icon(Icons.compare_arrows_rounded)),
              Tab(child: Icon(Icons.home_rounded)),
              Tab(child: Icon(Icons.menu_book_rounded)),
            ]),
      ),
      body: SafeArea(
        child: TabBarView(
          children: [
            Share(),
            bookList(),
            Text("test"),
          ],
        ),
      ),
    );
  }
}
