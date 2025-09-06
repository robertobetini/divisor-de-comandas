class People {
  String _name;
  String get name => _name;

  set name(String name) {
    _name = name;
    qName = name.toLowerCase();
  }

  late String qName;
  bool isDeleted = false;
  DateTime createdAt = DateTime.now();
  int id = 0;

  People(this._name) {
    qName = _name.toLowerCase();
  }

  People.fromDb(this.id, this._name, int timestamp) {
    qName = _name.toLowerCase();
    createdAt = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }
}
