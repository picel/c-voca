import 'package:CVoca/Model/BookDBModel.dart';
import 'package:CVoca/db.dart';
import 'package:flutter/material.dart';

class BookListController {
  static Color newColor = Colors.black;
  static Color selectedColor = Colors.amber;
  static TextEditingController inputController = TextEditingController();
  static String bookTitle = '';
  static List bookIds = [];
  static List books = [];
  static int count = 0;
  static int value = 0;

  static changeBookTitle() {
    bookTitle = inputController.text;
  }

  static changeNewColor(Color color) {
    newColor = color;
  }

  static changeSelectedColor(Color color) {
    selectedColor = color;
  }

  static Future getBookList() async {
    books = await BookManager.instance.getBooks();
    bookIds = List.generate(books.length, (index) => index);
  }

  static Future bookAdd() async {
    int id = 0;
    id = await BookManager.instance.getHighestId();
    await BookManager.instance.add(
      Book(
          id: id,
          bookname: bookTitle,
          bookcolor: '0x${selectedColor.value.toRadixString(16)}'),
    );
    bookTitle = '';
  }
}
