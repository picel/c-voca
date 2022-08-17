import 'package:CVoca/Controller/ColorController.dart';
import 'package:flutter/material.dart';
import 'package:CVoca/bookInfo.dart';
import 'package:CVoca/style.dart';
import 'package:CVoca/db.dart';
import 'package:CVoca/Model/BookDBModel.dart';
import 'package:CVoca/Model/WordcardDBModel.dart';
import 'package:CVoca/wordAdd.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:CVoca/wordModify.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WordList extends StatefulWidget {
  final int bookId;
  const WordList({Key? key, required this.bookId}) : super(key: key);

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  List<WordCard> cards = [];
  int cardLength = 0;
  int popCount = 0;
  Book book = Book(
    id: 0,
    bookname: '',
    bookcolor: '',
  );
  Color bookColor = Colors.white;
  Color textColor = Colors.black;
  Color selectedColor = Colors.amber;
  Color tmp = Colors.black;
  Color buttonColor = Colors.black;
  String bookName = '';
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBookInfo(widget.bookId);
  }

  Future getWordList() async {
    List<WordCard> tmpCards =
        await CardManager.instance.getCards(widget.bookId);
    setState(() {
      cards = tmpCards;
      cardLength = cards.length;
    });
  }

  Future getBookInfo(int bookId) async {
    var tmpBook = await BookManager.instance.getBook(bookId);
    if (tmpBook != "") {
      setState(() {
        book = tmpBook;
        bookName = book.bookname;
        bookColor = Color(int.parse(book.bookcolor));
        textColor = ColorController.textColorDecision(bookColor);
        buttonColor = ColorController.oppsiteColor(bookColor);
      });
    }
    getWordList();
  }

  Future deleteWord(int id) async {
    await CardManager.instance.delete(id);
    getWordList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bookColor,
      floatingActionButton: FloatingActionButton(
          foregroundColor: ColorController.textColorDecision(textColor),
          backgroundColor: buttonColor,
          shape: CircleBorder(),
          child: Icon(Icons.add_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordAdd(
                  bookId: widget.bookId,
                ),
              ),
            ).then((_) => getBookInfo(widget.bookId));
          }),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    color: textColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    bookName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: textColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookInfo(
                              bookId: widget.bookId,
                              bookName: bookName,
                              bookColor:
                                  '0x${bookColor.value.toRadixString(16)}',
                            ),
                          ),
                        ).then((_) => getBookInfo(widget.bookId));
                      }),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cardLength,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.4,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WordModify(
                                                  cardId: cards[index].id,
                                                )),
                                      ).then((_) => getWordList());
                                    },
                                    icon: Icons.edit_rounded,
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  SlidableAction(
                                      onPressed: (BuildContext context) {
                                        deleteWord(cards[index].id);
                                      },
                                      icon: Icons.delete_rounded,
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                ],
                              ),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              cards[index].word,
                                              style: newTextStyle.subTitleText,
                                            ),
                                            Text(
                                              "(" +
                                                  (cards[index].pronun
                                                      as String) +
                                                  ")",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          cards[index].mean,
                                          style: newTextStyle.subTitleText,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      cards[index].explain as String,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
