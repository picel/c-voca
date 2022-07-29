import 'package:CVoca/bookInfo.dart';
import 'package:CVoca/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:CVoca/style.dart';
import 'package:CVoca/db.dart';
import 'package:CVoca/model.dart';
import 'package:CVoca/wordList.dart';

class bookList extends StatefulWidget {
  const bookList({Key? key}) : super(key: key);

  @override
  State<bookList> createState() => _bookListState();
}

class _bookListState extends State<bookList> {
  Color newColor = Colors.black;
  Color selectedColor = Colors.amber;
  TextEditingController inputController = TextEditingController();
  String bookTitle = '';
  List<Book> books = [];
  List bookIds = [];
  int count = 0;
  int value = 0;

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
    List idList = await BookManager.instance.getBookIds();
    int cnt = idList.length;
    setState(() {
      books = tmpbooks;
      bookIds = [];
      for (int i = 0; i < cnt; i++) {
        bookIds.add(i);
      }
    });
  }

  Future bookAdd() async {
    int id = 0;
    id = await BookManager.instance.getHighestId();
    await BookManager.instance.add(
      Book(
          id: id,
          bookname: bookTitle,
          bookcolor: '0x${selectedColor.value.toRadixString(16)}'),
    );
    setState(() {
      bookTitle = '';
    });
    getBookList();
  }

  colorPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  enableLabel: true,
                  onColorChanged: (Color color) {
                    setState(() {
                      newColor = color;
                    });
                  },
                  pickerColor: selectedColor,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      setState(() => selectedColor = newColor);
                      Navigator.of(context).pop();
                      titleInput(context);
                    })
              ]);
        });
  }

  titleInput(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Type Book\'s Title'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Return'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    colorPicker(context);
                  },
                ),
                ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () async {
                      setState(() => bookTitle = inputController.text);
                      Navigator.of(context).pop();
                      await bookAdd();
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Book List",
                style: newTextStyle.titleText,
              ),
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: () async {
                  new Future.delayed(Duration.zero, () {
                    colorPicker(context);
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ResponsiveGridList(
            desiredItemWidth: 120,
            minSpacing: 20,
            children: bookIds.map((i) {
              return MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WordList(
                                bookId: books[i].id,
                              )),
                    ).then((_) => getBookList());
                  },
                  onLongPress: () {
                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height / 2,
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height / 2),
                        items: [
                          PopupMenuItem(
                            child: Text('Info'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text('Export'),
                            value: 2,
                          ),
                        ]).then(
                      (value) {
                        if (value == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookInfo(
                                bookId: books[i].id,
                                bookName: books[i].bookname,
                                bookColor: books[i].bookcolor,
                              ),
                            ),
                          ).then((_) => getBookList());
                        } else if (value == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Export(
                                bookId: [books[i].id],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                  color: Color(int.parse(books[i].bookcolor)),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(books[i].bookname,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColorDecision(
                                Color(int.parse(books[i].bookcolor))),
                          )),
                    ],
                  ));
            }).toList(),
          ),
        ),
      ],
    );
  }
}
