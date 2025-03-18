class Film {
  String _director;
  String _title;
  List<String> _actors;
  double _totalRatings = 0;
  int _ratingCount = 0;

  Film(this._director, this._title, this._actors);

  String get director => _director;
  String get title => _title;
  List<String> get actors => _actors;

  set director(String newDirector) {
    if (newDirector.isNotEmpty) _director = newDirector;
  }

  set title(String newTitle) {
    if (newTitle.isNotEmpty) _title = newTitle;
  }

  set actors(List<String> newActors) {
    if (newActors.isNotEmpty) _actors = newActors;
  }

  void addRating(double rating) {
    if (rating >= 0 && rating <= 5) {
      _totalRatings += rating;
      _ratingCount++;
    }
  }

  double get averageRating {
    return _ratingCount > 0 ? _totalRatings / _ratingCount : -1;
  }

  void displayInfo() {
    print("Τίτλος ταινίας: $_title");
    print("Σκηνοθέτης ταινίας: $_director");
    print("Μέση Βαθμολογία ταινίας: ${averageRating.toStringAsFixed(1)}");
    print("Ηθοποιοί ταινίας:");
    for (var actor in _actors) {
      print("\t" + actor);
    }
  }
}

void main() {
  Film inferno = Film("Ron Howard", "Inferno", ["Tom Hanks", "Felicity Jones", "Omar Sy"]);
  
  inferno.addRating(5);
  inferno.addRating(4);
  inferno.addRating(3);
  
  inferno.displayInfo();
}
