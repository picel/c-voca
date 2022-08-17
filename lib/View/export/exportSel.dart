import 'package:CVoca/db.dart';
import 'package:CVoca/export/export.dart';
import 'package:CVoca/Model/BookDBModel.dart';
import 'package:CVoca/Model/WordcardDBModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:CVoca/style.dart';

class ExportSel extends StatefulWidget {
  const ExportSel({Key? key}) : super(key: key);

  @override
  State<ExportSel> createState() => _ExportSelState();
}

class _ExportSelState extends State<ExportSel> {
  List<Book> books = [];
  List cardCount = [];
  List<bool> isChecked = [];

  @override
  void initState() {
    super.initState();
    getBookList();
  }

  Color textColorDecision(Color color) {
    if (color.computeLuminance() > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Future getBookList() async {
    List<Book> tmpbooks = await BookManager.instance.getBooks();
    var tmpcardCnt = [];

    for (int i = 0; i < tmpbooks.length; i++) {
      tmpcardCnt
          .add((await CardManager.instance.getCards(tmpbooks[i].id)).length);
    }

    setState(() {
      books = tmpbooks;
      cardCount = tmpcardCnt;
      isChecked = List.generate(tmpbooks.length, (index) => false);
    });
  }

  Future<int> getCardsNum(int bookId) async {
    return (await CardManager.instance.getCards(bookId)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Select Books",
                  style: newTextStyle.subTitleText,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                                value: isChecked[index],
                                onChanged: (value) {
                                  setState(() {
                                    isChecked[index] = value!;
                                  });
                                }),
                            Text(
                              books[index].bookname,
                              style: newTextStyle.subTitleText,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "${cardCount[index]}",
                                  style: TextStyle(
                                    color: textColorDecision(
                                      Color(int.parse(books[index].bookcolor)),
                                    ),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(int.parse(books[index].bookcolor)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    List<int> bookIds = [];
                    for (int i = 0; i < isChecked.length; i++) {
                      if (isChecked[i]) {
                        bookIds.add(books[i].id);
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Export(
                          bookId: bookIds,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Export checked books',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
