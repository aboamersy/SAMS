class Students {
  final String id;
  final String name;
  final String year;
  Students({this.id, this.name, this.year});

  Map<String, dynamic> studentsMap() => {
        'name': name,
        'year': year,
        'number': id,
      };
}
