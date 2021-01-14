class Data {
  final String name;
  final String job;
  final int id;

  Data({this.name, this.job,this.id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'job': job,
      'id':id,
    };
  }
}
