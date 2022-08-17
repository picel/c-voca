import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:CVoca/db.dart';
import 'package:CVoca/Model/BookDBModel.dart';
import 'package:CVoca/style.dart';

class BookInfo extends StatefulWidget {
  final int bookId;
  final String bookName;
  final String bookColor;
  const BookInfo(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.bookColor})
      : super(key: key);

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  Color selectedColor = Colors.amber;
  Color bookColor = Colors.white;
  Color tmp = Colors.white;
  String bookName = '';
  int popCount = 0;
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      bookName = widget.bookName;
      inputController.text = bookName;
      bookColor = Color(int.parse(widget.bookColor));
      tmp = bookColor;
      selectedColor = bookColor;
    });
  }

  Future updateBook(int bookId, String bookName, Color bookColor) async {
    await BookManager.instance.update(
      Book(
        id: bookId,
        bookname: bookName,
        bookcolor: '0x${this.bookColor.value.toRadixString(16)}',
      ),
    );
  }

  Future deleteBook(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('This will delete book and all words in this book!'),
                const Text('You won\'t be able to revert this!'),
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
                child: const Text('Yes, delete it!'),
                onPressed: () async {
                  await BookManager.instance.delete(id);
                  await CardManager.instance.deleteAll(id);
                  Navigator.of(context).popUntil((_) => popCount++ >= 3);
                })
          ],
        );
      },
    );
  }

  colorPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Pick a New Color!'),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  enableLabel: true,
                  onColorChanged: (Color color) {
                    setState(() {
                      tmp = bookColor;
                      bookColor = color;
                    });
                  },
                  pickerColor: selectedColor,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      bookColor = tmp;
                    });
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      setState(() {
                        selectedColor = bookColor;
                      });
                      updateBook(widget.bookId, bookName, selectedColor);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  titleInput(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Type New Book\'s Title'),
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
              )),
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
                      setState(() => bookName = inputController.text);
                      Navigator.of(context).pop();
                      await updateBook(widget.bookId, bookName, bookColor);
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "$bookName's Info",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bookName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => titleInput(context),
                        child: Icon(Icons.edit_rounded),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Color',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.08,
                            decoration: BoxDecoration(
                              color: bookColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                                bookColor.value.toRadixString(16).substring(2)),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () => colorPicker(context),
                        child: Icon(Icons.edit_rounded),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => deleteBook(widget.bookId),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Delete Book and All Words',
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
