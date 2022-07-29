class WordCard {
  final int id;
  final int bookid;
  final String word;
  final String mean;
  final String? pronun;
  final String? explain;

  WordCard(
      {required this.id,
      required this.bookid,
      required this.word,
      required this.mean,
      this.pronun,
      this.explain});

  factory WordCard.fromMap(Map<String, dynamic> json) => new WordCard(
        id: json['id'],
        bookid: json['bookid'],
        word: json['word'],
        mean: json['mean'],
        pronun: json['pronun'],
        explain: json['explain'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookid': bookid,
      'word': word,
      'mean': mean,
      'pronun': pronun,
      'explain': explain,
    };
  }
}

class Book {
  final int id;
  final String bookname;
  final String bookcolor;

  Book({required this.id, required this.bookname, required this.bookcolor});

  factory Book.fromMap(Map<String, dynamic> map) => new Book(
        id: map['id'],
        bookname: map['bookname'],
        bookcolor: map['bookcolor'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookname': bookname,
      'bookcolor': bookcolor,
    };
  }
}
