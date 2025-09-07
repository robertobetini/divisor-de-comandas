class People {
  String name;

  bool isDeleted = false;
  DateTime createdAt = DateTime.now();
  int id = 0;

  People(this.name);

  People.fromDb(this.id, this.name, int timestamp) {
    createdAt = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }
}
