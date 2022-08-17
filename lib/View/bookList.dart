import 'package:CVoca/Controller/BookListController.dart';
import 'package:CVoca/Controller/ColorController.dart';
import 'package:CVoca/bookInfo.dart';
import 'package:CVoca/export/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:CVoca/style.dart';
import 'package:CVoca/wordList.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class bookList extends StatefulWidget {
  const bookList({Key? key}) : super(key: key);

  @override
  State<bookList> createState() => _bookListState();
}

class _bookListState extends State<bookList> {
  List books = [];
  List bookIds = [];

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  _refreshBooks() async {
    await BookListController.getBookList();
    setState(() {
      books = BookListController.books;
      bookIds = BookListController.bookIds;
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: MaterialPicker(
                            enableLabel: true,
                            onColorChanged: (Color color) =>
                                BookListController.changeNewColor(color),
                            pickerColor: BookListController.selectedColor,
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
                              setState(() =>
                                  BookListController.changeSelectedColor(
                                      BookListController.newColor));
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Type Book\'s Title'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          TextField(
                                            controller: BookListController
                                                .inputController,
                                            decoration: InputDecoration(
                                              labelText: 'Title',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text('Confirm'),
                                        onPressed: () async {
                                          setState(() => BookListController
                                              .changeBookTitle());
                                          Navigator.of(context).pop();
                                          await BookListController.bookAdd();
                                          _refreshBooks();
                                          print(BookListController.bookTitle);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  );
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
              return AnimationConfiguration.staggeredGrid(
                position: i,
                duration: const Duration(milliseconds: 375),
                columnCount: BookListController.count,
                child: ScaleAnimation(
                    child: FadeInAnimation(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WordList(
                                  bookId: books[i].id,
                                )),
                      ).then((_) => _refreshBooks());
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
                              color: ColorController.textColorDecision(
                                  Color(int.parse(books[i].bookcolor))),
                            )),
                      ],
                    ),
                  ),
                )),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
