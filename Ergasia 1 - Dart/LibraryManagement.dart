class Book {
  String title;
  List<String> authors;
  String genre;
  String isbn;

  Book(this.title, this.authors, this.genre, this.isbn);

  @override
  String toString() {
    return 'Τίτλος: $title, Συγγραφείς: ${authors.join(", ")}, Είδος: $genre, ISBN: $isbn';
  }
}

class Library {
  List<Book> books = [];

  void insertBook(Book book) {
    books.add(book);
  }

  void displayBooks() {
    for (var book in books) {
      print(book);
    }
  }

  Book? searchByISBN(String isbn) {
    return books.cast<Book?>().firstWhere((book) => book?.isbn == isbn, orElse: () => null);
  }

  List<Book> searchByTitle(String title) {
    return books.where((book) => book.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  List<Book> searchByGenre(String genre) {
    return books.where((book) => book.genre.toLowerCase() == genre.toLowerCase()).toList();
  }
}

void main() {
  var library = Library();
  
  library.insertBook(Book("Η Φόνισσα", ["Αλέξανδρος Παπαδιαμάντης"], "Λογοτεχνία", "978-960-425-059-2"));
  library.insertBook(Book("Εραγκον", ["Κριστοφερ Παολινι"], "Λογοτεχνία", "978-990-456-059-3"));
  library.insertBook(Book("Η Ανθρωπότητα", ["Γιούβαλ Νώε Χαράρι"], "Επιστημονικό", "978-960-507-027-4"));
  library.insertBook(Book("Το Κεφάλαιο", ["Καρόλος Μαρξ"], "Οικονομία", "978-960-348-226-0"));

  print("Όλα τα βιβλία στη βιβλιοθήκη:");
  library.displayBooks();

  print("\n Αναζήτηση με ISBN (978-960-507-027-4):");
  print(library.searchByISBN("978-960-507-027-4") ?? "Δεν βρέθηκε");

  print("\n Αναζήτηση με τίτλο ( Το Κεφάλαιο):");
  print(library.searchByTitle(" Το Κεφάλαιο"));

  print("\n Αναζήτηση με είδος (Λογοτεχνία):");
  print(library.searchByGenre("Λογοτεχνία"));
}