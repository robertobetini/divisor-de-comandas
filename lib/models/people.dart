class People {
  String name;
  late String qName;
  bool isDeleted = false;
  DateTime createdAt = DateTime.now();
  int id = 0;

  People(this.name) {
    qName = name.toLowerCase();
  }

  People.fromDb(this.id, this.name, int timestamp) {
    qName = name.toLowerCase();
    createdAt = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }
}
