import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:CVoca/model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CardManager {
  CardManager._privateConstructor();
  static final CardManager instance = CardManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = p.join(documentsDirectory, 'cards.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY,
        bookid INTEGER,
        word TEXT,
        mean TEXT,
        pronun TEXT,
        explain TEXT
      )
    ''');
  }

  Future<int> add(WordCard card) async {
    Database db = await database;
    return await db.insert('cards', card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getHighestId() async {
    Database db = await database;
    List<Map> maps =
        await db.query('cards', columns: ['id'], orderBy: 'id DESC');
    if (maps.isNotEmpty) {
      return maps[0]['id'];
    } else {
      return 0;
    }
  }

  Future<List<WordCard>> getCards(int bookId) async {
    Database db = await database;
    var cards = await db.query('cards',
        orderBy: 'id ASC', where: 'bookid = ?', whereArgs: [bookId]);
    List<WordCard> cardList = cards.isNotEmpty
        ? cards.map((card) => WordCard.fromMap(card)).toList()
        : [];
    return cardList;
  }

  Future getCard(int id) async {
    Database db = await database;
    var card = await db.query('cards', where: 'id = ?', whereArgs: [id]);
    return card.isNotEmpty ? WordCard.fromMap(card.first) : "";
  }

  Future<int> update(WordCard card) async {
    Database db = await database;
    return await db
        .update('cards', card.toMap(), where: 'id = ?', whereArgs: [card.id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll(int bookId) async {
    Database db = await database;
    return await db.delete('cards', where: 'bookid = ?', whereArgs: [bookId]);
  }

  //read all cards with bookid = bookId and return a json string except the id and bookid fields
  Future getCardsJson(int bookId) async {
    var res = [];
    var cards = await getCards(bookId);
    for (var card in cards) {
      res.add(
        {
          'word': card.word,
          'mean': card.mean,
          'pronun': card.pronun,
          'explain': card.explain,
        },
      );
    }
    return res;
  }
}

class BookManager {
  BookManager._privateConstructor();
  static final BookManager instance = BookManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = p.join(documentsDirectory, 'books.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        bookname TEXT,
        bookcolor TEXT
      )
    ''');
  }

  Future<int> getHighestId() async {
    Database db = await database;
    List<Map> maps =
        await db.query('books', columns: ['id'], orderBy: 'id DESC');
    if (maps.isNotEmpty) {
      return maps[0]['id'] + 1;
    } else {
      return 0;
    }
  }

  Future<int> add(Book book) async {
    Database db = await instance.database;
    return await db.insert('books', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getBooks() async {
    Database db = await instance.database;
    var books = await db.query('books', orderBy: 'id');
    List<Book> bookList =
        books.isNotEmpty ? books.map((c) => Book.fromMap(c)).toList() : [];
    return bookList;
  }

  Future getBook(int id) async {
    Database db = await instance.database;
    var book = await db.query('books', where: 'id = ?', whereArgs: [id]);
    return book.isNotEmpty ? Book.fromMap(book.first) : "";
  }

  Future<int> update(Book book) async {
    Database db = await instance.database;
    return await db
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> count() async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM books')) ??
        0;
    return count;
  }

  Future delete(int id) async {
    Database db = await instance.database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
    await CardManager.instance.deleteAll(id);
  }

  Future getBookColor(int id) async {
    Database db = await instance.database;
    var book = await db.query('books',
        where: 'id = ?', whereArgs: [id], orderBy: 'id');
    return book[0]['bookcolor'];
  }

  //get book ids
  Future<List> getBookIds() async {
    Database db = await instance.database;
    var books = await db.query('books', orderBy: 'id');
    List bookIds = books.isNotEmpty ? books.map((c) => c['id']).toList() : [];
    return bookIds;
  }

  Future<String> getBooksJson(List bookIds) async {
    var books = [];
    for (int i = 0; i < bookIds.length; i++) {
      var book = await getBook(bookIds[i]);
      var cards = await CardManager.instance.getCardsJson(bookIds[i]);
      books.add({
        'bookname': book.bookname,
        'bookcolor': book.bookcolor,
        'cards': cards
      });
    }
    return json.encode(books);
  }
}
