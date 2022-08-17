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
